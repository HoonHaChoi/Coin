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
        let isExistLogHandler: (Date) -> Bool
        
        func pushTradingLogAddView(style: FormStyle) -> AnyPublisher<TradingLog, Never> {
            let subject: PassthroughSubject<TradingLog, Never> = .init()
            
            let tradingLogAddStore =
                TradingLogAddStore(environment:
                                    .init(onDismissSubject: subject,
                                          existDate: isExistLogHandler))
            
            let tradingLogAddViewController = TradingLogAddViewController.instantiate { coder in
                return TradingLogAddViewController(coder: coder, style: style)
            }
            
            tradingLogAddViewController.dispatch = tradingLogAddStore.dispatch(_:)
            tradingLogAddStore.updateView = tradingLogAddViewController.updateView
            
            viewController.navigationController?
                .pushViewController(tradingLogAddViewController,
                                    animated: true)
            return subject.map { log  in
                    viewController.navigationController?.popViewController(animated: true)
                    return log
                }.eraseToAnyPublisher()
        }
    }
    
    struct Environment {
        var dateManager: DateManagerProtocol
        var coreDataManager: CoreDataStorage
    }
    
    struct Reducer {
        typealias Action = TradingLogViewController.Action
        
        let environment: Environment
        let navigator: Navigator
        
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
                return navigator.pushTradingLogAddView(style: .add)
                    .map { log in Action.addTradingLog(log) }
                    .eraseToAnyPublisher()
                
            case let .addTradingLog(log):
                environment.coreDataManager.insert(tradingLog: log)
                updateState(state: &state)
                
            case let .deleteTradingLog(date):
                environment.coreDataManager.delete(date: date)
                updateState(state: &state)
                
            case let .didTapEditTradingLog(log):
                return navigator.pushTradingLogAddView(style: .edit(log))
                    .map { log in Action.editTradingLog(log) }
                    .eraseToAnyPublisher()
                
            case let .editTradingLog(log):
                environment.coreDataManager.update(tradingLog: log)
                updateState(state: &state)
                
            case .didTapDateAscending:
                updateState(state: &state)
            }
            return Empty().eraseToAnyPublisher()
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
        return Reducer(environment: environment,
                       navigator: navigator)
    }
    
    @Published private(set) var state: State
    private var environment: Environment
    private var navigator: Navigator
    private var cancell = Set<AnyCancellable>()
    var updateState: ((TradingLogViewController.ViewState) -> Void)?
    
    init(environment: Environment,
         navigator: Navigator) {
        self.state = .empty
        self.environment = environment
        self.navigator = navigator
        
        $state.dropFirst().sink(receiveValue: { [weak self] state in
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
