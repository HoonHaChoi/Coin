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
        static let empty = Self(selectDate: "",
                                startAmount: "",
                                endAmount: "",
                                memo: "",
                                isFormValid: false
                                )
        var selectDate: String
        var startAmount: String
        var endAmount: String
        var memo: String?
        var isFormValid: Bool
    }
    
    struct Environment {}
    
    struct Reducer {
        typealias Action = TradingLogAddViewController.Action
        
        func reduce(_ action: Action, state: inout State) {
            switch action {
            case .dateInput(let date):
                state.selectDate = date
                state.isFormValid = isFormValidCheck(state)
            case .startAmountInput(let amount):
                break
            case .endAmountInput(let amount):
                break
            case .memoInput(let memo):
                break
            }
        }
        
        private var isFormValidCheck: (State) -> Bool = { state in
            return !state.selectDate.isEmpty &&
                !state.startAmount.isEmpty &&
                !state.endAmount.isEmpty

        }
    }
    
    private var reducer: Reducer {
        return Reducer()
    }
    
    @Published private(set) var state: State
    private var cancellable: AnyCancellable?
    
    init(state: State) {
        self.state = state
    }
    
}
