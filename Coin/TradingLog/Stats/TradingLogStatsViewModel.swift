//
//  TradingLogStatsViewModel.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/16.
//

import Foundation

struct TradingLogStatsViewModel {
    
    private var statsState: TradingLogStatsDTO
        
    init(state: TradingLogStatsDTO = .empty) {
        statsState = state
    }
    
    
}
