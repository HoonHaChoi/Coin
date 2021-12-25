import Foundation
import Combine

final class SearchViewModel {
    
    private let searchService: NetworkService
    private let favoriteCoinRepository: FavoriteCoinRepository
    private var cancell: AnyCancellable?
    
    var coinsHandler: (([Coin]) -> Void)?
    var loadingHiddenStateHandler: ((Bool) -> Void)?
    var errorHandler: ((NetworkError) -> Void)?
    
    init(usecase: NetworkService,
         repository: FavoriteCoinRepository) {
        self.searchService = usecase
        self.favoriteCoinRepository = repository
    }
    
    func fetchSearchCoins(keyword: String, exchange: String) {
        loadingHiddenStateHandler?(false)
        cancell = requestSearchCoins(keyword: keyword, exchange: exchange)
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

extension SearchViewModel {
    private func requestSearchCoins(keyword: String, exchange: String) -> AnyPublisher<[Coin], NetworkError> {
        let url = Endpoint.tickerURL(type: .search(keyword, exchange))
        return searchService.requestPublisher(url: url)
    }
}
