import Foundation
import Combine

final class SearchViewModel {
    
    private let searchService: SearchService
    private let favoriteCoinRepository: FavoriteCoinRepository
    private var cancell: AnyCancellable?
    
    var coinsHandler: (([Coin]) -> Void)?
    var loadingHiddenStateHandler: ((Bool) -> Void)?
    var errorHandler: ((NetworkError) -> Void)?
    
    init(usecase: SearchService,
         repository: FavoriteCoinRepository) {
        self.searchService = usecase
        self.favoriteCoinRepository = repository
    }
    
    func fetchSearchCoins(keyword: String, exchange: String) {
        guard let url = Endpoint.tickerURL(type: .search(keyword, exchange)) else {
            return
        }
        loadingHiddenStateHandler?(false)
        cancell = searchService.requestSearchCoins(url: url)
            .sink { [weak self] (fail) in
                if case .failure(let error) = fail {
                    self?.errorHandler?(error)
                }
            } receiveValue: { [weak self] (coins) in
                self?.coinsHandler?(coins)
                self?.loadingHiddenStateHandler?(true)
            }
    }
    
    func registeredFavoriteCoinFetch() -> [String] {
        return favoriteCoinRepository.fetch()
    }
    
    func updateFavoriteCoin(from uuid: String) {
        let findUUID = favoriteCoinRepository.find(uuid: uuid)
        if findUUID {
            favoriteCoinRepository.delete(uuid: uuid)
        } else {
            favoriteCoinRepository.insert(uuid: uuid)
        }
    }
}
