//
//  ExchangeViewModel.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/24.
//

import Foundation
import Combine

final class ExchangeViewModel {
    
    private let searchUseCase: SearchUseCase
    private var cancell: AnyCancellable?
    
    var coinsHandler: (([Coin]) -> Void)?
    var failErrorHandler: ((NetworkError) -> Void)?
    
    init(usecase: SearchUseCase = NetworkManager()) {
        self.searchUseCase = usecase
    }
    
    func fetchCoins(from market: Exchange) {
        guard let url = Endpoint.exchangeURL(market: market) else {
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
