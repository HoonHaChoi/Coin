//
//  TradingLogStatsService.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/16.
//

import Foundation

final class TradingLogStatsService {
    
    private let dateManager: DateManager
    private let coreDataManager: CoreDataStorage
    
    private var firstLog: TradingLogMO?
    private var lastLog: TradingLogMO?
    private var logRegistedCount: Int
    private var finishPrice: Int
    
    init(dateManager: DateManager,
         coreDataManager: CoreDataStorage) {
        self.dateManager = dateManager
        self.coreDataManager = coreDataManager
        
        self.logRegistedCount = 0
        self.finishPrice = 0
    }

    func moveNextMonth() {
        dateManager.turnOfForward()
    }
    
    func movePreviousMonth() {
        dateManager.turnOfBackward()
    }
    
    private func fetch() {
        let logs = coreDataManager.fetch(dates: dateManager.calculateMonthStartOfEnd())

        guard let first = logs.first,let firstDate = first.date,
              let last = logs.last,let lastDate = last.date else {
            
            return
        }
        
        if firstDate < lastDate {
            firstLog = logs.first
            lastLog = logs.last
        } else {
            firstLog = logs.last
            lastLog = logs.first
        }
        
        logRegistedCount = logs.count
        finishPrice = Int(last.endPrice)
    }
    
    private func statsProfit(first: TradingLogMO,
                             last: TradingLogMO) -> Int {
        return Int(last.endPrice - first.startPrice)
    }
    
    private func statsRate(first: TradingLogMO,
                           last: TradingLogMO) -> Double {
        return Double((last.endPrice - first.startPrice)) / Double(first.startPrice) * 100
    }
    
}
