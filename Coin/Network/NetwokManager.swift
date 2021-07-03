import Foundation
import Combine

protocol SearchUseCase {
    func requestSearchCoins(url: String) -> AnyPublisher<[Coins], NetworkError>
}

final class NetworkManager: SearchUseCase {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func requestSearchCoins(url: String) -> AnyPublisher<[Coins], NetworkError> {
        return self.session.requestResource(url: url)
    }
}
