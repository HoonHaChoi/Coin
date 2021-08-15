//
//  TradingLogStatsService.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/16.
//

import Foundation

enum MonthMoveAction {
    case next
    case previous
}

struct TradingLogStatsViewModel {
    
    private let dateManager: DateManager
    private let coreDataManager: CoreDataFetching
    
    init(dateManager: DateManager,
         coreDataManager: CoreDataFetching) {
        self.dateManager = dateManager
        self.coreDataManager = coreDataManager
    }

    func moveMonth(action: MonthMoveAction) {
        switch action {
        case .next:
            dateManager.turnOfForward()
        case .previous:
            dateManager.turnOfBackward()
        }
    }
    
    func fetch() -> TradingLogStatsDTO {
        let logs = coreDataManager.fetchAscent(dates: dateManager.calculateMonthStartOfEnd())

        guard let first = logs.first, let last = logs.last else {
            return .empty
        }
        
        return .init(stats: .init(startPrice: Int(first.startPrice),
                                  endPrice: Int(last.endPrice),
                                  logCount: logs.count),
                     nextButtonState: dateManager.confirmNextMonth(),
                     previousButtonState: dateManager.confirmPreviousMonth(),
                     currentDateString: dateManager.currentDateString())
    }
    
}
