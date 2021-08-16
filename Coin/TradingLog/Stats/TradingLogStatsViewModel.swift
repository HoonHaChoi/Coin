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

final class TradingLogStatsViewModel {
    
    private let dateManager: DateManager
    private let coreDataManager: CoreDataFetching
    
    var updateDTOHandler: ((TradingLogStatsDTO) -> Void)?
    
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
        fetchStats()
    }
    
    func fetchStats() {
        let logs = coreDataManager.fetchAscent(dates: dateManager.calculateMonthStartOfEnd())

        guard let first = logs.first, let last = logs.last else {
            updateDTOHandler?(.empty)
            return
        }
        
        updateDTOHandler?(.init(stats: .init(startPrice: Int(first.startPrice),
                                  endPrice: Int(last.endPrice),
                                  logCount: logs.count),
                     nextButtonState: dateManager.confirmNextMonth(),
                     previousButtonState: dateManager.confirmPreviousMonth(),
                     currentDateString: dateManager.currentDateString()))
    }
    
}
