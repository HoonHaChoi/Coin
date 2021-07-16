import Foundation
import Combine

final class SearchViewModel {
    
    private let searchUseCase: SearchUseCase
    
    private var cancell: AnyCancellable?
    private var cancellable = Set<AnyCancellable>()
    
    @Published var coins: [Coin] = []
    
    var coinsHandler: (([Coin]) -> Void)?
    
    init(usecase: SearchUseCase = NetworkManager()) {
        self.searchUseCase = usecase
    }
    
    func fetchSearchCoins(keyword: String) {
        cancell = searchUseCase.requestSearchCoins(url: EndPoint.searchURL, param: keyword)
            .sink { (fail) in
            if case .failure(let error) = fail {
                print(error)
            }
        } receiveValue: { [weak self] (coins) in
            self?.coinsHandler?(coins)
            self?.coins = coins
        }
    }
}
