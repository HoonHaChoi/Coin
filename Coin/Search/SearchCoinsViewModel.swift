import Foundation
import Combine

final class SearchViewModel {
    
    private let searchUseCase: SearchUseCase
    private var cancell: AnyCancellable?
    private let endpoint: URLGenerator
    
    var coinsHandler: (([Coin]) -> Void)?
    
    init(usecase: SearchUseCase = NetworkManager(),
         endpoint: URLGenerator) {
        self.searchUseCase = usecase
        self.endpoint = endpoint
    }
    
    func fetchSearchCoins(keyword: String) {
        guard let url = endpoint.url(path: .search(keyword)) else {
            return
        }
        
        cancell = searchUseCase.requestSearchCoins(url: url)
            .sink { (fail) in
                if case .failure(let error) = fail {
                    print(error)
                }
            } receiveValue: { [weak self] (coins) in
                self?.coinsHandler?(coins)
            }
    }
}
