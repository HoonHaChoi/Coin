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
    
    private let session: Requestable
    
    init(session: Requestable) {
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
        let urlRequest = makeURLRequest(url: url,
                                              method: method,
                                              body: body)
        return self.session.completeResponsePublisher(for: urlRequest)
    }
    
    func requestDeleteNotification(url: URL?, method: HTTPMethod) -> AnyPublisher<String, NetworkError> {
        let urlRequest = makeURLRequest(url: url, method: method)
        return self.session.requestResource(for: urlRequest)
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

final class NetworkManagerStub: Requestable {
    
    private let dummyCoin = Coin(uuid: "", exchange: .bithumb, ticker: "", market: "", englishName: "", meta: .init(tradePrice: "", changePrice: "", changeRate: "", accTradePrice24H: "", change: .even), logo: nil)
    private let isRequestSuccess: Bool
    
    init(isSuccess: Bool) {
        self.isRequestSuccess = isSuccess
    }
    
    func requestResource<T: Decodable>(url: URL?) -> AnyPublisher<T, NetworkError> {
        if isRequestSuccess {
            return Just(dummyCoin as! T)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        }
        return Fail(error: NetworkError.invalidResponse).eraseToAnyPublisher()
    }
    
    func requestResource<T>(for urlRequest: URLRequest?) -> AnyPublisher<T, NetworkError> where T : Decodable {
        if isRequestSuccess {
            return Just([dummyCoin] as! T)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        }
        return Fail(error: NetworkError.invalidResponse).eraseToAnyPublisher()
    }
    
    func completeResponsePublisher(for urlRequest: URLRequest?) -> AnyPublisher<Void, NetworkError> {
        return Just(()).setFailureType(to: NetworkError.self).eraseToAnyPublisher()
    }
}
