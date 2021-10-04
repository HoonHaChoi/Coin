//
//  TradingLogStatsChartDTO.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/17.
//

import Foundation

struct TradingLogStatsChartDTO {
    static var empty = Self(months: [],
                            percentages: [])
    let months: [String]
    let percentages: [Double]
}
