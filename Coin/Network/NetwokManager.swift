import Foundation
import Combine
import SwiftyJSON

struct NetworkManager: SearchService, FavortieService, AppStoreService,
                       NotificationService, NotificationInputService, NotificationCycleService {
    
    private let session: Requestable
    
    init(session: Requestable) {
        self.session = session
    }
    
    func requestSearchCoins(url: URL?) -> AnyPublisher<[Coin], NetworkError> {
        return self.session.requestResource(url: url)
    }
    
    func requestFavoriteCoins(uuidString: String) -> AnyPublisher<Coin, NetworkError> {
        return self.session.requestResource(url: Endpoint.tickerURL(type: .favorite(uuidString)))
    }
    
    func requestNotifications(url: URL?) -> AnyPublisher<[Notice], NetworkError> {
        return self.session.requestResource(url: url)
    }
    
    func requestCompleteNotification(url: URL?,
                                   method: HTTPMethod,
                                   body: Data) -> AnyPublisher<Void, NetworkError> {
        let urlRequest = makeURLRequest(url: url,
                                              method: method,
                                              body: body)
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
        if let url = url {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpBody = body
            urlRequest.httpMethod = method.rawValue
            urlRequest.addValue("application/json",forHTTPHeaderField: "Content-Type")
            return urlRequest
        }
        return nil
    }
}

protocol SearchService {
    func requestSearchCoins(url: URL?) -> AnyPublisher<[Coin], NetworkError>
}

protocol FavortieService: SearchService {
    func requestFavoriteCoins(uuidString: String) -> AnyPublisher<Coin, NetworkError>
}

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
    func requestFavoriteCoins(uuidString: String) -> AnyPublisher<Coin, NetworkError>
}

protocol NotificationCycleService {
    func requestNotificationCycle(url: URL?) -> AnyPublisher<[NotificationCycle], NetworkError>
}
