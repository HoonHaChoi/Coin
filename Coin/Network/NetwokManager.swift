import Foundation
import Combine
import SwiftyJSON

protocol SearchUseCase {
    func requestSearchCoins(url: URL?) -> AnyPublisher<[Coin], NetworkError>
    func requestFavoriteCoins(uuidString: String) -> AnyPublisher<Coin, NetworkError>
    func requestCompleteNotification(url: URL?, method: HTTPMethod, body: Data) -> AnyPublisher<Void, NetworkError>
    func requestNotifications(url: URL?) -> AnyPublisher<[Notifications], NetworkError>
    func requestDeleteNotification(url: URL?, method: HTTPMethod) -> AnyPublisher<String, NetworkError>
}

struct NetworkManager: SearchUseCase {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func requestSearchCoins(url: URL?) -> AnyPublisher<[Coin], NetworkError> {
        return self.session.requestResource(url: url)
    }
    
    func requestFavoriteCoins(uuidString: String) -> AnyPublisher<Coin, NetworkError> {
        return self.session.requestResource(url: Endpoint.favoriteURL(uuid: uuidString))
    }
    
    func requestNotifications(url: URL?) -> AnyPublisher<[Notifications], NetworkError> {
        return self.session.requestResource(url: url)
    }
    
    func requestCompleteNotification(url: URL?,
                                   method: HTTPMethod,
                                   body: Data) -> AnyPublisher<Void, NetworkError> {
        guard let urlRequest = makeURLRequest(url: url,
                                              method: method,
                                              body: body) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        return self.session.dataTaskPublisher(for: urlRequest).completeResponsePublisher()
    }
    
    func requestDeleteNotification(url: URL?, method: HTTPMethod) -> AnyPublisher<String, NetworkError> {
        let urlRequest = makeURLRequest(url: url, method: method)
        return self.session.requestResource(for: urlRequest)
    }
    
    private func makeURLRequest(url: URL?, method: HTTPMethod, body: Data? = nil) -> URLRequest? {
        if let url = url, let body = body {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpBody = body
            urlRequest.httpMethod = method.rawValue
            urlRequest.addValue("application/json",forHTTPHeaderField: "Content-Type")
            return urlRequest
        }
        return nil
    }
}
