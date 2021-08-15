//
//  TradingLogStatsState.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/16.
//

import Foundation

struct TradingLogStatsDTO {
    static var empty = Self(stats: .empty,
                            nextButtonState: false,
                            previousButtonState: false,
                            currentDateString: "")
    
    var stats: StatsDTO
    var nextButtonState: Bool
    var previousButtonState: Bool
    var currentDateString: String
}
