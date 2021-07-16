import Foundation
import Combine

final class SearchViewModel {
    
    private let searchUseCase: SearchUseCase
    
    private var cancell: AnyCancellable?
    private var cancellable = Set<AnyCancellable>()
    
    @Published var coins: [Coin] = []
    
    init(usecase: SearchUseCase = NetworkManager()) {
        self.searchUseCase = usecase
    }
    
    func fetchSearchCoins() {
        cancell = searchUseCase.requestSearchCoins(url: EndPoint.searchURL)
            .sink { (fail) in
            if case .failure(let error) = fail {
                print(error)
            }
        } receiveValue: { (coins) in
            self.coins = coins
        }
    }
}
