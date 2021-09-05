//
//  ExchangeViewModel.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/24.
//

import Foundation
import Combine

final class ExchangeViewModel: CryptoBaseViewModel {
    
    func fetchCoins(from market: Exchange) {
        guard let url = Endpoint.exchangeURL(market: market) else {
            return
        }
        
        cancell = searchUseCase.requestSearchCoins(url: url)
            .sink { [weak self] (fail) in
                if case .failure(let error) = fail {
                    self?.failErrorHandler?(error)
                }
            } receiveValue: { [weak self] (coins) in
                self?.coinsHandler?(coins)
                self?.fetchSocketExchangeMeta(from: market)
            }
    }
    
    func fetchSocketExchangeMeta(from exchange: Exchange) {
        socketUseCase.requestSocketExchange(from: exchange) { [weak self] (result: Result<[CoinMeta], NetworkError>) in
            switch result {
            case .success(let meta):
                self?.metaHandler?(meta)
            case .failure(let error):
                self?.failErrorHandler?(error)
            }
        }
    }
    
    func leaveEvent(from event: String) {
        socketUseCase.removeEmitHandler(from: [event])
    }
}
