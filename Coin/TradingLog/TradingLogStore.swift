//
//  TradingLogState.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/04.
//

import UIKit
import Combine

class TradingLogStore {
    
    struct State {
        static var empty = Self(tradlog: [],
                                nextButtonState: false,
                                previousButtonState: false,
                                currentDateString: "")
        var tradlog: [TradingLogMO]
        var nextButtonState: Bool
        var previousButtonState: Bool
        var currentDateString: String
    }
    
    struct Navigator {
        let viewController: UIViewController
        let findDataHandler: (Date) -> Bool
        
        func pushTradingLogAddView() -> AnyPublisher<TradingLog, Never> {
            let subject: PassthroughSubject<TradingLog, Never> = .init()
            let tradingLogAddStore = TradingLogAddStore(state: .empty,
                                                        environment: .init(onDismissSubject: subject,
                                                                           existData: findDataHandler))
            let tradingLogAddViewController = TradingLogAddViewController.instantiate { coder in
                return TradingLogAddViewController(coder: coder)
            }
            
            tradingLogAddViewController.dispatch = tradingLogAddStore.dispatch(_:)
            tradingLogAddStore.updateView = tradingLogAddViewController.updateView
            
            viewController.navigationController?
                .pushViewController(tradingLogAddViewController,
                                    animated: true)
            return subject
                .map { log -> TradingLog in
                    viewController.navigationController?.popViewController(animated: true)
                    return log
                }.eraseToAnyPublisher()
        }
    }
    
    struct Environment {
        var dateManager: DateManager
        var coreDataManager: CoreDataStorage
        var addTradingView: UIViewController
    }
    
    struct Reducer {
        typealias Action = TradingLogViewController.Action
        
        let environment: Environment
        
        func reduce(_ action: Action, state: inout State) -> AnyPublisher<Action, Never>? {
            switch action {
            
            case .loadInitialData:
                updateState(state: &state)
            case .didTapForWardMonth:
                environment.dateManager.turnOfForward()
                updateState(state: &state)
            case .didTapBackWardMonth:
                environment.dateManager.turnOfBackward()
                updateState(state: &state)
            case .didTapAddTradingLog:
                return Navigator(viewController: environment.addTradingView,
                                 findDataHandler: environment.coreDataManager.find(date:))
                    .pushTradingLogAddView()
                    .map { _ in Action.loadInitialData }
                    .eraseToAnyPublisher()
            }
            return nil
        }
        
        private func updateState(state: inout State) {
            state.tradlog = environment.coreDataManager.fetch(
                dates: environment.dateManager.calculateMonthStartOfEnd())
            state.nextButtonState = environment.dateManager.confirmNextMonth()
            state.previousButtonState = environment.dateManager.confirmPreviousMonth()
            state.currentDateString = environment.dateManager.currentDateString()
        }
    }
    
    private var reducer: Reducer {
        return Reducer(environment: environment)
    }
    
    @Published private(set) var state: State
    private var environment: Environment
    private var cancell = Set<AnyCancellable>()
    var updateState: ((TradingLogViewController.ViewState) -> Void)?
    
    init(state: State,
         environment: Environment) {
        self.state = state
        self.environment = environment
        
        $state.sink(receiveValue: { [weak self] state in
            self?.updateState?(TradingLogViewController.ViewState(state: state))
        }).store(in: &cancell)
    }
    
    func dispatch(_ action: TradingLogViewController.Action) {
        reducer.reduce(action, state: &state)
            .map { action in
                action.sink { [weak self] action in
                    self?.dispatch(action)
                }.store(in: &cancell)
            }
    }
}

private extension TradingLogViewController.ViewState {
    init(state: TradingLogStore.State) {
        self.tradlingLogs = state.tradlog
        self.nextButtonState = state.nextButtonState
        self.previousButtonState = state.previousButtonState
        self.currentDateString = state.currentDateString
    }
}
