//
//  MockNetworkManager.swift
//  CoinTests
//
//  Created by HOONHA CHOI on 2021/10/20.
//

import Foundation
import Combine

final class SearchServiceSpy: SearchService {
    
    let dummyModels: DummyModels
    
    var searchURLQuery: String?
    var isSuccess: Bool
    
    init(isSuccess: Bool) {
        self.dummyModels = .init()
        self.isSuccess = isSuccess
    }
    
    func requestSearchCoins(url: URL?) -> AnyPublisher<[Coin], NetworkError> {
        searchURLQuery = url?.query
        
        return Future<[Coin], NetworkError> { promise in
            if self.isSuccess {
                promise(.success([self.dummyModels.DummyCoin()]))
            } else {
                promise(.failure(.invalidRequest))
            }
        }.eraseToAnyPublisher()
    }

}

final class FakeFavoriteCoinRepository: FavoriteCoinRepository {
    
    private var dummyFavoriteCoinUUID: [String] = ["dummyUUID1", "dummyUUID2"]
    
    func fetch() -> [String] {
        return dummyFavoriteCoinUUID
    }
    
    @discardableResult
    func insert(uuid: String) -> Bool {
        dummyFavoriteCoinUUID.append(uuid)
        return true
    }
    
    @discardableResult
    func delete(uuid: String) -> Bool {
        if let index = dummyFavoriteCoinUUID.firstIndex(of: uuid) {
            dummyFavoriteCoinUUID.remove(at: index)
        }
        return true
    }
    
    @discardableResult
    func find(uuid: String) -> Bool {
        return dummyFavoriteCoinUUID.firstIndex(of: uuid) != nil
    }
}
