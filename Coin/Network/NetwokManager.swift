import Foundation
import Combine
import SwiftyJSON

protocol SearchUseCase {
    func requestSearchCoins(url: URL?) -> AnyPublisher<[Coin], NetworkError>
    func requestFavoriteCoins(uuidString: String) -> AnyPublisher<Coin, NetworkError>
    func requestNotification(url: URL?, method: HTTPMethod, body: Data) -> AnyPublisher<Void, NetworkError>
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
    
    func requestNotification(url: URL?,
                                   method: HTTPMethod,
                                   body: Data) -> AnyPublisher<Void, NetworkError> {
        guard let urlRequest = makeURLRequest(url: url,
                                              method: method,
                                              body: body) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        return self.session.dataTaskPublisher(for: urlRequest)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }
                guard 200..<300 ~= httpResponse.statusCode else {
                    throw NetworkError.invalidStatusCode(httpResponse.statusCode)
                }
                return
            }
            .mapError { error -> NetworkError in
                NetworkError.invalidResponse
            }.eraseToAnyPublisher()
    }
    
    private func makeURLRequest(url: URL?, method: HTTPMethod, body: Data) -> URLRequest? {
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
