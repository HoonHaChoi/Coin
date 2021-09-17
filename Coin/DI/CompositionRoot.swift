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
    
//    let changeColorMapper = EnumMapper(key: Change.allCases,
//                                  item: [UIColor.fallColor,
//                                         UIColor.basicColor,
//                                         UIColor.riseColor])
//    let changeSignMapper = EnumMapper(key: Change.allCases,
//                                      item: ["-","","+"])
    
    // MARK: CoreData
    var tradingLogCoreData: CoreDataStorageManager {
        return CoreDataStorageManager(modelName: "TradingLogModel",
                                      userSetting: userSetting)
    }
    
    var favoriteCoinCoreData: FavoriteCoinStorage = FavoriteCoinStorage(modelName: "FavoriteCoinModel")

    // MARK: DataSource
    typealias cryptoDataSource = TableDataSource<CryptoCell, Coin>
    var coinDataSource: cryptoDataSource { cryptoDataSource.init(emptyView: EmptyView(frame: .zero, title: "관심 있는 코인 목록이 비어 있습니다!", description: "관심 있는 코인을 검색 또는 거래소를 \n 통해 추가 해주세요")) { cell, model in
        cell.configure(coin: model,
                       imageLoader: self.imageLoader)
        }
    }
    
    // MARK: Coordinator
    func makeTabBarCoordinator(navigation: UINavigationController) -> TabBarCoordinator {
        return TabBarCoordinator(navigationController: navigation,
                                 dependency:
                                    .init(mainCoordinatorFactory: makeMainCoordinator,
                                          tradingLogCoordinatorFactory: makeTradingLogContainerCoordinator,
                                          notificationCoordinatorFactory: makeNotificaionsCoordinator))
    }
    
    private func makeMainCoordinator() -> MainCoordinator {
        return MainCoordinator(dependency:
                                .init(mainContainerViewControllerFactory: makeMainContainerViewController,
                                      searchViewControllerFactory: makeSearchViewController
                                      ,detailViewControllerFactory: makeDetailViewController(from:),
                                      notificationIntputViewControllerFactory: makeNotificationsInputViewController))
    }
    
    private func makeTradingLogCoordinator() -> TradingLogCoordinator {
        return TradingLogCoordinator(dependency:
                                        .init(tradingLogViewControllerFactory: makeTradingLogViewController))
    }
    
    private func makeTradingLogContainerCoordinator() -> TradingLogContanierCoordinator {
        return TradingLogContanierCoordinator(dependency: .init(tradingLogContainerViewControllerFactory: makeTradingLogContainerController))
    }
    
    private func makeNotificaionsCoordinator() -> NotificationsCoordinator {
        return NotificationsCoordinator(dependency:
                                            .init(notificationsViewControllerFactory: makeNotificationsViewController,
                                                  searchViewControllerFactory: makeSearchViewController(style:),
                                                  notificationIntputViewControllerFactory: makeNotificationsInputViewController))
    }
    
    // MARK: Controller
    private func makeMainContainerViewController() -> MainContainerViewController {
        let exchangeViewController = makeExchangeViewController()
        let mainViewController = makeMainController()
        let mainContainerViewController = MainContainerViewController(viewControllers: [mainViewController, exchangeViewController])
        
        mainViewController.didCellTapped = mainContainerViewController.pushDetailController(from:)
        exchangeViewController.didCellTapped = mainContainerViewController.pushDetailController(from:)
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
        
        exchangeViewController.requestLeaveEvent = exchangeViewModel.leaveEvent(from:)
        exchangeViewController.requestSocketMeta = exchangeViewModel.fetchSocketExchangeMeta(from:)
        
        exchangeViewController.requestLeaveCurrentEvent = exchangeViewModel.leaveCurrentEvent(complete:)
        exchangeViewController.requestExchangeSocket = exchangeViewModel.fetchCoinsSocket(from:)
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
        mainViewController.requestLeaveEvent = mainViewModel.leaveEvent
        return mainViewController
    }
    
    typealias SearchDataSource = TableDataSource<SearchCoinCell, Coin>
    private func makeSearchViewController(style: SearchStyle) -> SearchViewController {
        let viewModel = SearchViewModel(usecase: networkManager,
                                        repository: favoriteCoinCoreData)
        let searchDataSource = SearchTableDataSource { cell, coin, state in
            cell.configure(coin: coin,
                           imageLoader: imageLoader,
                           state: state)
            cell.searchStyle(style: style)
        }
        let searchViewController = SearchViewController.instantiate { coder in
            return SearchViewController(coder: coder,
                                        imageLoader: imageLoader,
                                        dataSource: searchDataSource,
                                        style: style)
        }
        
        searchDataSource.favoriteButtonTappedHandler = searchViewController.didfavoriteButtonAction
        
        viewModel.coinsHandler = searchViewController.updateSearchResult
        searchViewController.keywordHandler = viewModel.fetchSearchCoins(keyword:exchange:)
        searchViewController.fetchFavoriteCoin = viewModel.registeredFavoriteCoinFetch
        searchViewController.updateFavoriteHandler = viewModel.updateFavoriteCoin(from:)
        viewModel.loadingHiddenStateHandler = searchViewController.loadingHiddenState
        
        searchViewController.title = style == .favorite ? "관심 코인 설정" : "검색"
        return searchViewController
    }
    
    private func makeDetailViewController(from coin: Coin) -> DetailViewController {
        let viewModel = DetailViewModel(repository: favoriteCoinCoreData,
                                        searchUseCase: networkManager,
                                        socketUseCase: socketRepository)
        let detailViewController = DetailViewController(coin: coin,
                                                        imageLoader: imageLoader)
        
        detailViewController.coinFindHandler = viewModel.findFavoriteCoin(from:)
        detailViewController.favoriteButtonAction = viewModel.updateFavoriteCoin(from:)
        
        detailViewController.requestJoinEvent = viewModel.fetchSocketMeta(from:)
        detailViewController.requestLeaveEvent = viewModel.leaveEvent(from:)
        
        viewModel.metaHandler = detailViewController.updateInfoUI
        viewModel.failErrorHandler = detailViewController.showError
        
        return detailViewController
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
    
    private func makeNotificationsViewController() -> NotificationsViewController {
        typealias NotificationDataSource = TableDataSource<NotificationCell, Notifications>
        let viewmodel = NotificationsViewModel(usecase: networkManager)
        let notificationDataSource = NotificationDataSource.init(emptyView: EmptyView(frame: .zero, title: "알림 목록이 비어 있어요!", description: "+버튼으로 원하는 금액에 도달하는 코인을 \n 등록하고 알림을 받아보세요")) { cell, noti in
            cell.configure(from: noti)
        }
        let notificationsViewController = NotificationsViewController(dataSource: notificationDataSource)
        
        notificationsViewController.requestNotifications = viewmodel.fetchNotifications
        viewmodel.notificationsHandler = notificationsViewController.updateNotifications
        viewmodel.errorHandler = notificationsViewController.showError
        viewmodel.loadingHiddenStateHandler = notificationsViewController.loadingHiddenState
        
        notificationsViewController.requestDeleteNotification = viewmodel.deleteNotification(uuid:)
        viewmodel.completeMessageHanlder = notificationsViewController.completeMessage
        
        return notificationsViewController
    }
    
    private func makeNotificationsInputViewController(uuid: String, formStyle: NotificationInputFormStyle) -> NotificationInputViewController {
        let notificationHelper = NotificationHelper()
        let viewModel = NotificationInputViewModel(usecase: networkManager,
                                                   notificationHelper: notificationHelper)
        let viewController = NotificationInputViewController(uuid: uuid,
                                                             imageLoader: imageLoader,
                                                             type: notificationHelper.notificationTypeNames,
                                                             cycle: notificationHelper.cycleNames,
                                                             formStyle: formStyle)
        
        viewModel.coinHandler = viewController.updateInfoView
        viewModel.errorHandler = viewController.showError
        viewModel.isValidCheckHandler = viewController.updateCompleteButtonState
        viewController.basePriceHandler = viewModel.update(text:type:)
        viewController.cycleHandler = viewModel.update(text:type:)
        viewController.requestCoinHandler = viewModel.fetchSearchCoin(uuid:)
        
        viewModel.successHandler = viewController.onDismiss
        viewController.requestNotification = viewModel.requestCreateNotification(type:uuid:)
        
        return viewController
    }
}
