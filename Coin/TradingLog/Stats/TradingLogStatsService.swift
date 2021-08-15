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
    
    init(dateManager: DateManager,
         coreDataManager: CoreDataStorage) {
        self.dateManager = dateManager
        self.coreDataManager = coreDataManager
    }

    func moveNextMonth() {
        dateManager.turnOfForward()
    }
    
    func movePreviousMonth() {
        dateManager.turnOfBackward()
    }
    
    private func fetch() -> TradingLogStatsDTO {
        let logs = coreDataManager.fetch(dates: dateManager.calculateMonthStartOfEnd())

        guard let first = logs.first,let firstDate = first.date,
              let last = logs.last,let lastDate = last.date else {
            return .empty
        }
        return .empty
    }
    
}
