//
//  CoinSortHelp.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/26.
//

import Foundation

struct CoinSortHelper {
    
    func sortTicker(coins: [Coin],
                    action: PlusMinusAction,
                    handler: ([Coin]) ->()) {
        var model = coins
        switch action {
        case .plus:
            model = model.sorted { $0.ticker > $1.ticker }
        case .minus:
            model = model.sorted { $0.ticker < $1.ticker }
        }
        handler(model)
    }
    
    func sortTradePrice(coins: [Coin],
                        action: PlusMinusAction,
                        handler: ([Coin]) ->()) {
        var model = coins
        switch action {
        case .plus:
            model = model.sorted {
                let first = Double($0.meta.tradePrice) ?? 0.0
                let second = Double($1.meta.tradePrice) ?? 0.0
                return first > second
            }
        case .minus:
            model = model.sorted {
                let first = Double($0.meta.tradePrice) ?? 0.0
                let second = Double($1.meta.tradePrice) ?? 0.0
                return first < second
            }
        }
        handler(model)
    }
    
    func sortChangeRate(coins: [Coin],
                        action: PlusMinusAction,
                        handler: ([Coin]) ->()) {
        var model = coins
        switch action {
        case .plus:
            model = model.sorted {
                let first = convertDouble(value: $0.meta.changeRate,
                                          changeState: $0.meta.change)
                let second = convertDouble(value: $1.meta.changeRate,
                                           changeState: $1.meta.change)
                return first > second
            }
        case .minus:
            model = model.sorted {
                let first = convertDouble(value: $0.meta.changeRate,
                                          changeState: $0.meta.change)
                let second = convertDouble(value: $1.meta.changeRate,
                                           changeState: $1.meta.change)
                return first < second
            }
        }
        handler(model)
    }
    
    private func convertDouble(value: String, changeState: Change) -> Double {
        let convertRate = Double(value) ?? 0.0
        if changeState == .fall {
            return -convertRate
        }
        return convertRate
    }
}
