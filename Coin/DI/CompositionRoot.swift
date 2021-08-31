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
    let networkManager = NetworkManager()
    let coinSortHelper = CoinSortHelper()
    
    var socketRepository: SocketRepository {
        return SocketRepository(socket: socket)
    }
    
    let changeColorMapper = EnumMapper(key: Change.allCases,
                                  item: [UIColor.fallColor,
                                         UIColor.basicColor,
                                         UIColor.riseColor])
    let changeSignMapper = EnumMapper(key: Change.allCases,
                                      item: ["-","","+"])
    
    // MARK: CoreData
    var tradingLogCoreData: CoreDataStorageManager {
        return CoreDataStorageManager(modelName: "TradingLogModel",
                                      userSetting: userSetting)
    }
    
    var favoriteCoinCoreData: FavoriteCoinStorage = FavoriteCoinStorage(modelName: "FavoriteCoinModel")

    // MARK: DataSource
    typealias cryptoDataSource = TableDataSource<CryptoCell, Coin>
    var coinDataSource: cryptoDataSource { cryptoDataSource.init { cell, model in
        cell.configure(coin: model,
                       imageLoader: self.imageLoader,
                       colorMapper: self.changeColorMapper,
                       signMapper: self.changeSignMapper)
        }
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
                                .init(mainContainerViewControllerFactory: makeMainContainerViewController,
                                      searchViewControllerFactory: makeSearchViewController
                                      ))
    }
    
    private func makeTradingLogCoordinator() -> TradingLogCoordinator {
        return TradingLogCoordinator(dependency:
                                        .init(tradingLogViewControllerFactory: makeTradingLogViewController))
    }
    
    private func makeTradingLogContainerCoordinator() -> TradingLogContanierCoordinator {
        return TradingLogContanierCoordinator(dependency: .init(tradingLogContainerViewControllerFactory: makeTradingLogContainerController))
    }
    
    // MARK: Controller
    private func makeMainContainerViewController() -> MainContainerViewController {
        let exchangeViewController = makeExchangeViewController()
        let mainViewController = makeMainController()
        let mainContainerViewController = MainContainerViewController(viewControllers: [mainViewController, exchangeViewController])
        return mainContainerViewController
    }
    
    private func makeExchangeViewController() -> ExchangeViewController {
        let exchangeViewModel = ExchangeViewModel(searchUsecase: networkManager,
                                                  socketUsecase: socketRepository)
        let exchangeViewController = ExchangeViewController(dataSource: coinDataSource,
                                                            coinSortHelper: coinSortHelper)
        
        exchangeViewController.requestExchange = exchangeViewModel.fetchCoins(from:)
        exchangeViewModel.coinsHandler = exchangeViewController.updateTableView(coins:)
        exchangeViewModel.metaHandler = exchangeViewController.updateMeta(metaList:)
        exchangeViewModel.failErrorHandler = exchangeViewController.onAlertError(message:)
        
        exchangeViewController.requestDisConnectSocket = exchangeViewModel.disConnectSocket
        exchangeViewController.requestSocketMeta = exchangeViewModel.fetchSocketExchangeMeta(from:)
        
        return exchangeViewController
    }
    
    private func makeMainController() -> MainViewController {
        
        let mainViewModel = MainViewModel(repository: favoriteCoinCoreData,
                                          searchUseCase: networkManager,
                                          socketUseCase: socketRepository)
        let mainViewController = MainViewController(dataSource: coinDataSource)
        
        mainViewModel.failErrorHandler = mainViewController.showError
        mainViewModel.coinsHandler = mainViewController.updateCoinList
        mainViewController.fetchCoinsHandler = mainViewModel.fetchFavoriteCoins
        
        mainViewModel.metaHandler = mainViewController.updateMeta(metaList:)
        mainViewController.requestDisConnectSocket = mainViewModel.disConnectSocket
        return mainViewController
    }
    
    typealias SearchDataSource = TableDataSource<SearchCoinCell, Coin>
    private func makeSearchViewController() -> SearchViewController {
        let viewModel = SearchViewModel(usecase: networkManager,
                                        repository: favoriteCoinCoreData)
        let searchDataSourece = SearchDataSource.init { cell , coin in
            cell.configure(coin: coin, imageLoader: imageLoader)
        }
        let searchViewController = SearchViewController.instantiate { coder in
            return SearchViewController(coder: coder,
                                        viewModel: viewModel,
                                        dataSource: searchDataSourece)
        }
        
        viewModel.coinsHandler = searchViewController.updateSearchResult
        searchViewController.keywordHandler = viewModel.fetchSearchCoins(keyword:)
        searchViewController.fetchFavoriteCoin = viewModel.registeredFavoriteCoinFetch
        
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
                               coreDataManager: tradingLogCoreData,
                               addTradingView: tradingLogViewController))
        
        
        tradingLogViewController.dispatch = tradingLogStore.dispatch(_:)
        tradingLogStore.updateState = tradingLogViewController.updateState(state:)
        return tradingLogViewController
    }
    
    private func makeTradingLogStatsViewController() -> TradingLogStatsViewController {
        let dateManager = DateManager()
        let chartHelper = ChartHelper(manager: tradingLogCoreData)
        let tradingLogStatsViewModel = TradingLogStatsViewModel(dateManager: dateManager,
                                                                coreDataManager: tradingLogCoreData,
                                                                chartDTOFactory: chartHelper)
        let tradingLogStatsViewController = TradingLogStatsViewController.instantiate { coder in
            return TradingLogStatsViewController(coder: coder)
        }
        
        tradingLogStatsViewController.moveMonthAction = tradingLogStatsViewModel.moveMonth(action:)
        tradingLogStatsViewModel.updateDTOHandler = tradingLogStatsViewController.updateUI(dto:)
        tradingLogStatsViewController.requestStats = tradingLogStatsViewModel.fetchStats
        return tradingLogStatsViewController
    }
    
    private func makeTradingLogContainerController() -> TradingLogContanierViewController {
        
        let tradingLogViewController = makeTradingLogViewController()
        let tradingLogStatsViewController = makeTradingLogStatsViewController()
        
        tradingLogViewController.statsViewUpdateHandler = tradingLogStatsViewController.requestStats
        
        let tradingLogContanierViewController = TradingLogContanierViewController.instantiate { coder in
            return TradingLogContanierViewController(coder: coder,
                                                     tradingLogController: tradingLogViewController,
                                                     tradingLogStatsController: tradingLogStatsViewController)
        }
        return tradingLogContanierViewController
    }
}
