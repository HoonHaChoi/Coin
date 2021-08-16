//
//  StatsDTO.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/16.
//

import Foundation
import UIKit

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
    
    var stateColor: UIColor {
        if endPrice - startPrice > 0 {
            return .riseColor
        } else if endPrice - startPrice == 0 {
            return .basicColor
        } else {
            return .fallColor
        }
    }
}
