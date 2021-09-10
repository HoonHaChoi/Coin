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
    
    var isValidCheckHandler: ((Bool) -> ())?
    
    func update(text: String, type: NotificationInputType) {
        switch type {
        case .basePrice:
            basePriceText = text
        case .cycle:
            cycleText = text
        }
        isValidCheckHandler?(isFormValidCheck())
    }
    
    func isFormValidCheck() -> Bool {
        return !basePriceText.isEmpty &&
            !cycleText.isEmpty
    }
}


