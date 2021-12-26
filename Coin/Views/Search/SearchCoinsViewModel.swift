import Foundation
import Combine

final class SearchViewModel: BaseViewModel {
    
    private let favoriteCoinRepository: FavoriteCoinRepository
    
    var coinsHandler: (([Coin]) -> Void)?
    var loadingHiddenStateHandler: ((Bool) -> Void)?
    var errorHandler: ((NetworkError) -> Void)?
    
    init(service: NetworkService, repository: FavoriteCoinRepository) {
        self.favoriteCoinRepository = repository
        super.init(service: service)
    }
    
    func fetchSearchCoins(keyword: String, exchange: String) {
        loadingHiddenStateHandler?(false)
        requestSearchCoins(keyword: keyword, exchange: exchange)
            .sink { [weak self] (fail) in
                if case .failure(let error) = fail {
                    self?.errorHandler?(error)
                }
            } receiveValue: { [weak self] (coins) in
                self?.coinsHandler?(coins)
                self?.loadingHiddenStateHandler?(true)
            }.store(in: &cancellable)
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
        return service.requestPublisher(url: url)
    }
}
