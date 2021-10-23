//
//  TradingLog.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/30.
//

import Foundation

struct TradingLog {
    
    var startPrice: Int
    var endPrice: Int
    var date: Date
    var memo: String?
    
    func rate() -> Double {
        let rate =  Double((endPrice - startPrice)) / Double(startPrice) * 100
        return rate.cutDecimalPoint()
    }

    func profit() -> Int {
        return endPrice - startPrice
    }
    
    var change: Change {
        if endPrice - startPrice > 0 {
            return .rise
        } else if endPrice - startPrice == 0 {
            return .even
        } else {
            return .fall
        }
    }
}
