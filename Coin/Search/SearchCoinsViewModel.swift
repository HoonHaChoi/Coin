import Foundation
import Combine

final class SearchViewModel {
    
    private let searchUseCase: SearchUseCase
    private var cancell: AnyCancellable?
    
    var coinsHandler: (([Coin]) -> Void)?
    
    init(usecase: SearchUseCase = NetworkManager()) {
        self.searchUseCase = usecase
    }
    
    func fetchSearchCoins(keyword: String) {
        let url = EndPoint.searchURL(keyword: keyword)
        cancell = searchUseCase.requestSearchCoins(url: url)
            .sink { (fail) in
            if case .failure(let error) = fail {
                print(error)
            }
        } receiveValue: { [weak self] (coins) in
            self?.coinsHandler?(coins)
        }
    }
    
    func updateHandlerRemove() {
        coinsHandler = nil
    }
}
