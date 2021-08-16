//
//  StatsDTO.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/16.
//

import Foundation

struct StatsDTO {
    
    static var empty = Self(startPrice: 0,
                            endPrice: 0,
                            logCount: 0)
    
    var startPrice: Int
    var endPrice: Int
    var logCount: Int
    
    func endPirceString() -> String {
        return endPrice.convertPriceKRW()
    }
    
    func logCountString() -> String {
        return "\(logCount)"+"일"
    }
    
    func rate() -> String {
        let rate = Double((endPrice - startPrice)) / Double(startPrice) * 100
        return rate.convertRateString()
    }

    func profit() -> String {
        return (endPrice - startPrice).convertPriceKRW()
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
}
