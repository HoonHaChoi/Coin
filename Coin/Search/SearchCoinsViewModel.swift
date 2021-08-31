import Foundation
import Combine

final class SearchViewModel {
    
    private let searchUseCase: SearchUseCase
    private let favoriteCoinRepository: FavoriteCoinRepository
    private var cancell: AnyCancellable?
    
    var coinsHandler: (([Coin]) -> Void)?
    
    init(usecase: SearchUseCase,
         repository: FavoriteCoinRepository) {
        self.searchUseCase = usecase
        self.favoriteCoinRepository = repository
    }
    
    func fetchSearchCoins(keyword: String) {
        guard let url = Endpoint.searchURL(keyword: keyword) else {
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
    
    func registeredFavoriteCoinFetch() -> [String] {
        return favoriteCoinRepository.fetch()
    }
}
