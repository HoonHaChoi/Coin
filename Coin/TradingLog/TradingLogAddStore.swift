//
//  TradingLogAddStore.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/05.
//

import Foundation
import Combine

final class TradingLogAddStore {
    
    struct State {
        var startAmount: String
        var endAmount: String
    }
    
    struct Environment {
        
    }
    
    struct Reducer {
        
    }
    
    @Published private(set) var state: State
    
    init(state: State) {
        self.state = state
    }
    
}
