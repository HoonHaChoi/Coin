//
//  TradingLogState.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/04.
//

import Foundation

class TradingLogState {
    
    struct State {
        static var empty = Self(tradlog: [])
        var tradlog: [TradingLogMO]
    }
    
    struct Reducer {
        typealias Action = TradingLogViewController.Action
        func reduce(_ action: Action, state: inout State) {
            
        }
    }
}

