//
//  TradingLogStatsState.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/16.
//

import Foundation

struct TradingLogStatsDTO {
    var stats: StatsDTO
    var nextButtonState: Bool
    var previousButtonState: Bool
    var currentDateString: String
}

extension TradingLogStatsDTO {
    init(nextButtonState: Bool,
         previousButtonState: Bool,
         currentDateString: String) {
        stats = .empty
        self.nextButtonState = nextButtonState
        self.previousButtonState = previousButtonState
        self.currentDateString = currentDateString
    }
}
