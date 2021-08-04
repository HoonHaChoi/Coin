//
//  TradingLogState.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/04.
//

import Foundation
import Combine

class TradingLogStore {
    
    struct State {
        static var empty = Self(tradlog: [])
        var tradlog: [TradingLogMO]
    }

    struct Environment {
        var dateManager: DateManager
        var coreDataManager: CoreDataStorage
    }
    
    struct Reducer {
        typealias Action = TradingLogViewController.Action
        
        let environment: Environment
        
        func reduce(_ action: Action, state: inout State) {
            switch action {
            
            case .loadInitialData:
                state.tradlog = environment.coreDataManager.fetch()
            case .didTapForWardMonth:
                break
            case .didTapBackWardMonth:
                break
            }
        }
    }
    
    private var reducer: Reducer {
        return Reducer(environment: environment)
    }
    
    @Published private(set) var state: State
    private var environment: Environment
    private var cancell: AnyCancellable?
    var updateState: ((TradingLogViewController.ViewState) -> Void)?
    
    init(state: State,
         environment: Environment) {
        self.state = state
        self.environment = environment
        
        cancell = $state.sink(receiveValue: { [weak self] state in
            self?.updateState?(TradingLogViewController.ViewState(state: state))
        })
    }
    
    func dispatch(_ action: TradingLogViewController.Action) {
        reducer.reduce(action, state: &state)
    }
}

private extension TradingLogViewController.ViewState {
    init(state: TradingLogStore.State) {
        self.tradlingLogs = state.tradlog
    }
}
