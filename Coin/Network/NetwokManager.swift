import Foundation
import Combine

protocol NetworkService {
    func requestPublisher<T: Decodable>(url: URL?) -> AnyPublisher<T, NetworkError>
}

protocol NotificationNetworkService: NetworkService {
    func requestPublisher<T: Decodable>(url: URL?, method: HTTPMethod, body: Data?) -> AnyPublisher<T, NetworkError>
}

struct NetworkManager: NetworkService, NotificationNetworkService {
    
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
    
    func requestAppStoreVersion(url: URL?) -> AnyPublisher<AppInfo, NetworkError> {
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

extension NetworkManager: AppStoreService {}

protocol AppStoreService {
    func requestAppStoreVersion(url: URL?) -> AnyPublisher<AppInfo, NetworkError>
}
