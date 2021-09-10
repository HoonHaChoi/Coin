//
//  NotificationInputViewModel.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/10.
//

import Foundation
import Combine

enum NotificationInputType {
    case basePrice
    case cycle
}

final class NotificationInputViewModel {
    
    private var basePriceText: String
    private var cycleText: String
    
    init() {
        basePriceText = ""
        cycleText = ""
    }
    
    func update(text: String, type: NotificationInputType) -> Bool {
        switch type {
        case .basePrice:
            basePriceText = text
        case .cycle:
            cycleText = text
        }
        return isFormValidCheck()
    }
    
    func isFormValidCheck() -> Bool {
        return !basePriceText.isEmpty &&
            !cycleText.isEmpty
    }
}


