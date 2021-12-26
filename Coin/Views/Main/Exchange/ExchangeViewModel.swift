//
//  ExchangeViewModel.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/24.
//

import Foundation
import Combine

final class ExchangeViewModel: CryptoBaseViewModel {
    
    func fetchCoins(from exchange: Exchange, isSocketConnect: Bool) {
        cancell = requestExchangeCoins(from: exchange)
            .sink { [weak self] (fail) in
                if case .failure(let error) = fail {
                    self?.failErrorHandler?(error)
                }
            } receiveValue: { [weak self] (coins) in
                self?.coinsHandler?(coins)
                if isSocketConnect {
                    self?.fetchSocketExchangeMeta(from: exchange)
                }
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
    
    func leaveCurrentEvent(complete: (() -> Void)) {
        socketUseCase.removeCurrentEmit(complete: complete)
    }
    
}

extension ExchangeViewModel {
    private func requestExchangeCoins(from exchange: Exchange) -> AnyPublisher<[Coin], NetworkError> {
        return service.requestPublisher(url: Endpoint.tickerURL(type: .exchange(exchange.title)))
    }
}
