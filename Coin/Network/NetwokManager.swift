import Foundation
import Combine

protocol SearchUseCase {
    func requestSearchCoins(url: URL?) -> AnyPublisher<[Coin], NetworkError>
}

final class NetworkManager: SearchUseCase {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func requestSearchCoins(url: URL?) -> AnyPublisher<[Coin], NetworkError> {
        return self.session.requestResource(url: url)
    }
}
