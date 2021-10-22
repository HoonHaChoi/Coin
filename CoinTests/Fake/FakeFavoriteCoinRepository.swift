//
//  FakeFavoriteCoinRepository.swift
//  CoinTests
//
//  Created by HOONHA CHOI on 2021/10/22.
//

import Foundation

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
