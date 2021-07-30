//
//  TradingLog.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/30.
//

import Foundation

struct TradingLog {
    
    enum Market {
        case fall
        case even
        case rise
        
        var state: String {
            switch self {
            case .even:
                return "EVEN"
            case .fall:
                return "FALL"
            case .rise:
                return "RISE"
            }
        }
    }
    
    var startPrice: Int
    var endPrice: Int
    var date: Date
    
    lazy var rate: Double = Double((endPrice - startPrice)) / Double(startPrice) * 100
    lazy var profit: Int = endPrice - startPrice
    
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
