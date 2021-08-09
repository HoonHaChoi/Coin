//
//  TradingLogController+Extension.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/04.
//

import Foundation

extension TradingLogViewController {
    enum Action {
        case loadInitialData
        case didTapForWardMonth
        case didTapBackWardMonth
        case didTapAddTradingLog
        case addTradingLog(TradingLog)
        case deleteTradingLog(Date)
    }
    
    struct ViewState {
        var tradlingLogs: [TradingLogMO]
        var nextButtonState: Bool
        var previousButtonState: Bool
        var currentDateString: String
    }
}
