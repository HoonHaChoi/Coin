//
//  MarketButtonFactory.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/22.
//

import UIKit

struct MarketButtonFactory {
    
    private let marketList: [String]
    
    init(list: [String]) {
        self.marketList = list
    }
    
    func createMarketButtons() -> [MarketButton] {
        var buttons: [MarketButton] = []
        
        marketList.forEach { title in
            let button = MarketButton(type: .system)
            button.setTitle(title, for: .normal)
            buttons.append(button)
        }
        
        // 첫번째 버튼은 선택되어 있는 상태를 표시
        buttons.first?.isSelected = true
        return buttons
    }
    
}
