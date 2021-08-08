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
    
    struct Environment {
        let onDismissSubject: PassthroughSubject<TradingLog, Never>
        let existData: (Date) -> Bool
    }
    
    struct Reducer {
        typealias Action = TradingLogAddViewController.Action
        
        let environment: Environment
        
        func reduce(_ action: Action, state: inout State) {
            switch action {
            case let .dateInput(date):
                if environment.existData(date.removeTimeStamp()) {

                } else {
                    state.selectDate = date.convertString()
                    state.isFormValid = isFormValidCheck(state)
                }
            case let .startAmountInput(amount):
                state.startAmount = amount.limitTextCount()
                state.isFormValid = isFormValidCheck(state)
            case let .endAmountInput(amount):
                state.endAmount = amount.limitTextCount()
                state.isFormValid = isFormValidCheck(state)
            case let .memoInput(memo):
                state.memo = memo
            case .addTradingLog:
                environment.onDismissSubject
                    .send(TradingLog(startPrice: Int(state.startAmount) ?? 0,
                                     endPrice: Int(state.endAmount) ?? 0,
                                     date: state.selectDate.convertDate()))
            }
        }
        
        var isFormValidCheck: (State) -> Bool = { state in
            return !state.selectDate.isEmpty &&
                !state.startAmount.isEmpty &&
                !state.endAmount.isEmpty
        }
    }
    
    private var reducer: Reducer {
        return Reducer(environment: environment)
    }
    
    @Published private(set) var state: State
    private var cancellable: AnyCancellable?
    private var environment: Environment
    var updateView: ((TradingLogAddViewController.ViewState) -> ())?
    
    init(state: State,
         environment: Environment) {
        self.state = state
        self.environment = environment
        
        cancellable = $state.sink(receiveValue: { [weak self] state in
            self?.updateView?(TradingLogAddViewController.ViewState(state: state))
        })
    }
    
    func dispatch(_ action: TradingLogAddViewController.Action) {
        reducer.reduce(action, state: &state)
    }
}

private extension TradingLogAddViewController.ViewState {
    init(state: TradingLogAddStore.State) {
        self.selectDate = state.selectDate
        self.startAmount = state.startAmount
        self.endAmount = state.endAmount
        self.memo = state.memo
        self.isFormValid = state.isFormValid
    }
}
