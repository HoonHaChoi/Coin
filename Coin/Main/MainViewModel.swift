//
//  MainViewModel.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/27.
//

import Foundation
import Combine

final class MainViewModel: CryptoBaseViewModel {
    
    func fetchCoins(uuids: [String]) {
        let requests = uuids.map { uuid in
            return searchUseCase.requestFavoriteCoins(uuidString: uuid)
        }
        
        cancell = Publishers.MergeMany(requests)
            .collect()
            .sink { [weak self] fail in
                if case .failure(let error) = fail {
                    self?.failErrorHandler?(error)
                }
            } receiveValue: { [weak self] coins in
                self?.coinsHandler?(coins)
            }
    }
}
