//
//  MockNetworkManager.swift
//  CoinTests
//
//  Created by HOONHA CHOI on 2021/10/20.
//

import Foundation
import Combine

final class SearchServiceSpy: BaseSpy, SearchService {
    
    var searchURLQuery: String?
    
    func requestSearchCoins(url: URL?) -> AnyPublisher<[Coin], NetworkError> {
        searchURLQuery = url?.query
        
        return Future<[Coin], NetworkError> { promise in
            if self.isSuccess {
                promise(.success([self.dummyModel.createDummyCoin()]))
            } else {
                promise(.failure(.invalidRequest))
            }
        }.eraseToAnyPublisher()
    }
}
