import Foundation
import Combine

final class SearchViewModel {
    
    private let searchUseCase: SearchUseCase
    private let favoriteCoinRepository: FavoriteCoinRepository
    private var cancell: AnyCancellable?
    
    var coinsHandler: (([Coin]) -> Void)?
    var loadingHiddenStateHandler: ((Bool) -> Void)?
    
    init(usecase: SearchUseCase,
         repository: FavoriteCoinRepository) {
        self.searchUseCase = usecase
        self.favoriteCoinRepository = repository
    }
    
    func fetchSearchCoins(keyword: String, exchange: String) {
        guard let url = Endpoint.searchURL(keyword: keyword,
                                           exchange: exchange) else {
            return
        }
        loadingHiddenStateHandler?(false)
        cancell = searchUseCase.requestSearchCoins(url: url)
            .sink { (fail) in
                if case .failure(let error) = fail {
                    print(error)
                }
            } receiveValue: { [weak self] (coins) in
                self?.coinsHandler?(coins)
                self?.loadingHiddenStateHandler?(true)
            }
    }
    
    func registeredFavoriteCoinFetch() -> [String] {
        return favoriteCoinRepository.fetch()
    }
    
    func insertFavoriteCoin(from uuid: String) {
        favoriteCoinRepository.insert(uuid: uuid)
    }
    
    func deleteFavoriteCoin(from uuid: String) {
        favoriteCoinRepository.delete(uuid: uuid)
    }
}
