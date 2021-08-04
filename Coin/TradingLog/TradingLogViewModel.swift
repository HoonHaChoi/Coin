//
//  TradingLogViewModel.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/03.
//

import Foundation

struct TradingLogViewModel {
    
    private var storage: CoreDataStorage
    
    init(storage: CoreDataStorage) {
        self.storage = storage
    }
    
//    func fetchLog() -> [TradingLogMO] {
//        return storage.fetch()
//    }
    
    func insertLog(start: Int, end: Int, date: Date) {
        storage.insert(start: start, end: end, date: date)
    }
    
    func updateLog(index: Int, start: Int,
                   end: Int) {
        storage.update(index: index, start: start, end: end)
    }
    
    func deleteLog(index: Int) {
        storage.delete(index: index)
    }
}
