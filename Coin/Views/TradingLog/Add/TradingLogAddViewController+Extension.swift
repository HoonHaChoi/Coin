//
//  TradingLogAddViewController+Extension.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/06.
//

import UIKit

extension TradingLogAddViewController {
    
    enum Action {
        case dateInput(Date)
        case startAmountInput(String)
        case endAmountInput(String)
        case memoInput(String)
        case addTradingLog(String)
        case alertDissmiss
        case editInput(Date)
    }
    
    struct ViewState {
        var selectDate: String?
        var startAmount: String?
        var endAmount: String?
        var memo: String
        var isFormValid: Bool
        var alert: UIAlertController?
    }
}

