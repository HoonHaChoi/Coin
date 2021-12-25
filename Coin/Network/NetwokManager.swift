import Foundation
import Combine

protocol NetworkService {
    func requestPublisher<T: Decodable>(url: URL?) -> AnyPublisher<T, NetworkError>
}

protocol NotificationNetworkService: NetworkService {
    func requestPublisher<T: Decodable>(url: URL?, method: HTTPMethod, body: Data?) -> AnyPublisher<T, NetworkError>
}

struct NetworkManager {
    
    private let session: Requestable
    
    init(session: Requestable) {
        self.session = session
    }
    
    func requestPublisher<T: Decodable>(url: URL?) -> AnyPublisher<T, NetworkError> {
        return session.requestResource(url: url)
    }
    
    func requestPublisher<T: Decodable>(url: URL?, method: HTTPMethod, body: Data?) -> AnyPublisher<T, NetworkError> {
        let urlRequest = makeURLRequest(url: url, method: method, body: body)
        return self.session.requestResource(for: urlRequest)
    }
    
    func requestSearchCoins(url: URL?) -> AnyPublisher<[Coin], NetworkError> {
        return self.session.requestResource(url: url)
    }
    
    func requestFavoriteCoins(url: URL?) -> AnyPublisher<Coin, NetworkError> {
        return self.session.requestResource(url: url)
    }
    
    func requestNotifications(url: URL?) -> AnyPublisher<[Notice], NetworkError> {
        return self.session.requestResource(url: url)
    }
    
    func requestCompleteNotification(url: URL?, method: HTTPMethod, body: Data) -> AnyPublisher<Void, NetworkError> {
        let urlRequest = makeURLRequest(url: url, method: method, body: body)
        return self.session.completeResponsePublisher(for: urlRequest)
    }
    
    func requestAppStoreVersion(url: URL?) -> AnyPublisher<AppInfo, NetworkError> {
        return self.session.requestResource(url: url)
    }
    
    func requestDeleteNotification(url: URL?, method: HTTPMethod) -> AnyPublisher<String, NetworkError> {
        let urlRequest = makeURLRequest(url: url, method: method)
        return self.session.requestResource(for: urlRequest)
    }
    
    func requestNotificationCycle(url: URL?) -> AnyPublisher<[NotificationCycle], NetworkError> {
        return self.session.requestResource(url: url)
    }
    
    private func makeURLRequest(url: URL?, method: HTTPMethod, body: Data? = nil) -> URLRequest? {
        guard let url = url else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpBody = body
        urlRequest.httpMethod = method.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return urlRequest
    }
    
}
extension NetworkManager: NetworkService {}
extension NetworkManager: NotificationNetworkService {}
extension NetworkManager: AppStoreService {}
extension NetworkManager: NotificationService {}
extension NetworkManager: NotificationInputService {}
extension NetworkManager: NotificationCycleService {}

protocol AppStoreService {
    func requestAppStoreVersion(url: URL?) -> AnyPublisher<AppInfo, NetworkError>
}

protocol NotificationBaseService {
    func requestCompleteNotification(url: URL?, method: HTTPMethod, body: Data) -> AnyPublisher<Void, NetworkError>
}
protocol NotificationService: NotificationBaseService {
    func requestNotifications(url: URL?) -> AnyPublisher<[Notice], NetworkError>
    func requestDeleteNotification(url: URL?, method: HTTPMethod) -> AnyPublisher<String, NetworkError>
}

protocol NotificationInputService: NotificationBaseService {
    func requestFavoriteCoins(url: URL?) -> AnyPublisher<Coin, NetworkError>
}

protocol NotificationCycleService {
    func requestNotificationCycle(url: URL?) -> AnyPublisher<[NotificationCycle], NetworkError>
}
