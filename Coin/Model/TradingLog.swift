//
//  TradingLog.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/30.
//

import UIKit

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
    
    var market: Market {
        if endPrice - startPrice > 0 {
            return .rise
        } else if endPrice - startPrice == 0 {
            return .even
        } else {
            return .fall
        }
    }
    
    func marketColor() -> UIColor {
        switch market{
        case .rise:
            return .riseColor
        case .fall:
            return .fallColor
        case .even:
            return .basicColor
        }
    }
}
