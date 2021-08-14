//
//  CompositionRoot.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/28.
//

import UIKit

struct AppDependency {
    
    let imageLoader = ImageLoader()
    let socket = Socket(url: Endpoint.socketURL)
    let userSetting = UserSetting()
    
    private func makeTradingLogCoreData() -> CoreDataStorageManager {
        return CoreDataStorageManager(modelName: "TradingLogModel",
                                      userSettingfetch: userSetting)
    }
    
    // MARK: Coordinator
    func makeTabBarCoordinator(navigation: UINavigationController) -> TabBarCoordinator {
        return TabBarCoordinator(navigationController: navigation,
                                 dependency:
                                    .init(mainCoordinatorFactory: makeMainCoordinator,
                                          tradingLogCoordinatorFactory: makeTradingLogContainerCoordinator))
    }
    
    private func makeMainCoordinator() -> MainCoordinator {
        return MainCoordinator(dependency:
                                .init(mainViewControllerFactory: makeMainController,
                                      searchViewControllerFactory: makeSearchViewController))
    }
    
    private func makeTradingLogCoordinator() -> TradingLogCoordinator {
        return TradingLogCoordinator(dependency:
                                        .init(tradingLogViewControllerFactory: makeTradingLogViewController))
    }
    
    private func makeTradingLogContainerCoordinator() -> TradingLogContanierCoordinator {
        return TradingLogContanierCoordinator(dependency: .init(tradingLogContainerViewControllerFactory: makeTradingLogContainerController,
                                                                tradingLogViewControllerFactory: makeTradingLogViewController))
    }
    
    // MARK: Controller
    private func makeMainController() -> MainViewController {
        let socketRepository = SocketRepository(socket: socket)
        let mainDataSource = MainDataSourece(imageLoader: imageLoader)
        let mainViewModel = MainViewModel(usecase: socketRepository)
        let mainViewController = MainViewController.instantiate { coder in
            return MainViewController(coder: coder,
                                      dataSource: mainDataSource)
        }
        
        mainViewModel.errorHandler = mainViewController.showError
        mainViewModel.coinListHandler = mainViewController.updateCoinList
        mainViewController.fetchCoinsHandler = mainViewModel.fetchCoins
        
        return mainViewController
    }
    
    private func makeSearchViewController() -> SearchViewController {
        let viewModel = SearchViewModel()
        let searchDataSourece = SearchCoinDataSource(imageLoader: imageLoader)
        let searchViewController = SearchViewController.instantiate { coder in
            return SearchViewController(coder: coder,
                                        viewModel: viewModel,
                                        dataSource: searchDataSourece)
        }
        
        viewModel.coinsHandler = searchViewController.updateSearchResult
        searchViewController.keywordHandler = viewModel.fetchSearchCoins(keyword:)
        
        searchViewController.title = "검색"
        return searchViewController
    }
    
    private func makeTradingLogViewController() -> TradingLogViewController {
        let dateManager = DateManager()
        let tradingLogDataSource = TradingLogDataSource()
        let tradingLogViewController = TradingLogViewController.instantiate { coder in
            return TradingLogViewController(coder: coder,
                                            dataSource: tradingLogDataSource,
                                            userSettingChange: userSetting)
        }
        
        let tradingLogStore = TradingLogStore(
            state: .empty,
            environment: .init(dateManager: dateManager,
                               coreDataManager: makeTradingLogCoreData(),
                               addTradingView: tradingLogViewController))
        
        
        tradingLogViewController.dispatch = tradingLogStore.dispatch(_:)
        tradingLogStore.updateState = tradingLogViewController.updateState(state:)
        return tradingLogViewController
    }
    
    private func makeTradingLogStatsViewController() -> TradingLogStatsViewController {
        let tradingLogStatsViewController = TradingLogStatsViewController.instantiate { coder in
            return TradingLogStatsViewController(coder: coder)
        }
        return tradingLogStatsViewController
    }
    
    private func makeTradingLogContainerController() -> TradingLogContanierViewController {
        let tradingLogContanierViewController = TradingLogContanierViewController.instantiate { coder in
            return TradingLogContanierViewController(coder: coder,
                                                     tradingLogController: makeTradingLogViewController())
        }
        return tradingLogContanierViewController
    }
}
