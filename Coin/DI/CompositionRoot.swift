//
//  CompositionRoot.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/28.
//

import UIKit
import CoreData
import FirebaseMessaging

struct AppDependency {
    
    let imageLoader = ImageLoader()
    let socket = Socket(url: Endpoint.socketURL)
    let networkManager = NetworkManager(session: URLSession.shared)
    let coinSortHelper = CoinSortHelper()
    
    var socketRepository: SocketRepository {
        return SocketRepository(socket: socket)
    }
    
    // MARK: FCM Token
    var fcmToken = Messaging.messaging().fcmToken ?? ""
    
    // MARK: CoreData
    var tradingLogCoreData = CoreDataStorageManager(container:
                                                        makePersistentContainer(modelName: "TradingLogModel"),
                                                    userSetting: userSetting)
    
    var favoriteCoinCoreData = FavoriteCoinStorage(container:
                                                    makePersistentContainer(modelName: "FavoriteCoinModel"))
    
    static func makePersistentContainer(modelName: String) -> NSPersistentContainer {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { store, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }
    
    static let userSetting = UserSetting()

    // MARK: DataSource
    typealias cryptoDataSource = TableDataSource<CryptoCell, Coin>
    var coinDataSource: cryptoDataSource { cryptoDataSource.init { cell, model in
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
                                          notificationCoordinatorFactory: makeNotificaionsCoordinator,
                                          setCoordinatorFactory: makeSetCoordinator))
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
    
    private func makeSetCoordinator() -> SetCoordinator {
        return SetCoordinator(dependency: .init(setViewControllerFactory: makeSetViewController))
    }
    
    // MARK: Controller
    func makeSplashViewController() -> SplashViewController {
        let nwMonitor = NWMonitor()
        let versionManager = VersionManager(service: networkManager)
        let splashViewController = SplashViewController(moniter: nwMonitor)
        splashViewController.requestAppVersion = versionManager.fetchAppStoreVersion
        versionManager.successHandler = splashViewController.showMainScreen
        versionManager.failRequestHandler = splashViewController.showFailRequestAlert
        versionManager.unequalVersionHandler = splashViewController.showNeedUpdateAlert
        versionManager.loadingStateHandler = splashViewController.changeLoadingState
        return splashViewController
    }
    
    private func makeMainContainerViewController() -> MainContainerViewController {
        let exchangeViewController = makeExchangeViewController()
        let mainViewController = makeMainController()
        let mainContainerViewController = MainContainerViewController(viewControllers: [mainViewController, exchangeViewController])
        
        mainViewController.didCellTapped = mainContainerViewController.pushDetailController(from:)
        exchangeViewController.didCellTapped = mainContainerViewController.pushDetailController(from:)
        return mainContainerViewController
    }
    
    private func makeExchangeViewController() -> ExchangeViewController {
        let exchangeViewModel = ExchangeViewModel(service: networkManager,
                                                  socketUsecase: socketRepository)
        let exchangeViewController = ExchangeViewController(dataSource: coinDataSource,
                                                            coinSortHelper: coinSortHelper)
        
        exchangeViewController.requestExchange = exchangeViewModel.fetchCoins(from:isSocketConnect:)
        exchangeViewController.requestLeaveEvent = exchangeViewModel.leaveEvent(from:)
        exchangeViewController.requestSocketMeta = exchangeViewModel.fetchSocketExchangeMeta(from:)
        exchangeViewController.requestLeaveCurrentEvent = exchangeViewModel.leaveCurrentEvent(complete:)
        
        exchangeViewModel.coinsHandler = exchangeViewController.updateTableView(coins:)
        exchangeViewModel.metaHandler = exchangeViewController.updateMeta(metaList:)
        exchangeViewModel.errorHandler = exchangeViewController.onAlertError(message:)
        
        return exchangeViewController
    }
    
    private func makeMainController() -> MainViewController {
        
        let mainViewModel = MainViewModel(repository: favoriteCoinCoreData,
                                          service: networkManager,
                                          socketUseCase: socketRepository)
        let mainViewController = MainViewController(dataSource: coinDataSource)
        
        mainViewModel.errorHandler = mainViewController.showError
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
        viewModel.errorHandler = searchViewController.showError
        
        searchViewController.title = style == .favorite ? "관심 코인 설정" : "검색"
        return searchViewController
    }
    
    private func makeDetailViewController(from coin: Coin) -> DetailViewController {
        let viewModel = DetailViewModel(repository: favoriteCoinCoreData,
                                        service: networkManager,
                                        socketUseCase: socketRepository)
        let detailViewController = DetailViewController(coin: coin,
                                                        imageLoader: imageLoader)
        
        detailViewController.coinFindHandler = viewModel.findFavoriteCoin(from:)
        detailViewController.favoriteButtonAction = viewModel.updateFavoriteCoin(from:)
        
        detailViewController.requestJoinEvent = viewModel.fetchSocketMeta(from:)
        detailViewController.requestLeaveEvent = viewModel.leaveEvent(from:)
        
        viewModel.metaHandler = detailViewController.updateInfoUI
        viewModel.errorHandler = detailViewController.showError
        
        return detailViewController
    }
    
    private func makeTradingLogViewController() -> TradingLogViewController {
        let dateManager = DateManager()
        let tradingLogDataSource = TradingLogDataSource()
        let tradingLogViewController = TradingLogViewController.instantiate { coder in
            return TradingLogViewController(coder: coder,
                                            dataSource: tradingLogDataSource,
                                            userSettingChange: AppDependency.userSetting)
        }
        
        let tradingLogStore = TradingLogStore(
            environment: .init(dateManager: dateManager,
                               coreDataManager: tradingLogCoreData),
            navigator: .init(viewController: tradingLogViewController,
                             isExistLogHandler: tradingLogCoreData.isExistLog(date:)))
        
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

        let viewmodel = NotificationsViewModel(service: networkManager, fcmToken: fcmToken)
        let notificationDataSource = NotificationDataSource()
        let notificationsViewController = NotificationsViewController(dataSource: notificationDataSource,
                                                                      imageLoader: imageLoader)
        
        notificationsViewController.requestNotifications = viewmodel.fetchNotifications
        viewmodel.notificationsHandler = notificationsViewController.updateNotifications
        viewmodel.errorHandler = notificationsViewController.showError
        viewmodel.loadingHiddenStateHandler = notificationsViewController.loadingHiddenState
        
        notificationsViewController.requestDeleteNotification = viewmodel.deleteNotification(uuid:)
        viewmodel.completeMessageHanlder = notificationsViewController.completeMessage
        
        notificationDataSource.switchActionHandler =
            notificationsViewController.receiveSwitchAction(cell:switch:)
        notificationsViewController.requestUpdateSwitch = viewmodel.updateNotificationSwitch(uuid:state:indexPath:)
        
        viewmodel.failureIndexHandler = notificationsViewController.restoreSetSwitch(indexPath:)
        return notificationsViewController
    }
    
    private func makeNotificationsInputViewController(notiObject: NotificationObject, formStyle: NotificationInputFormStyle) -> NotificationInputViewController {
        let notificationHelper = NotificationHelper(service: networkManager)
        let viewModel = NotificationInputViewModel(service: networkManager,
                                                   notificationHelper: notificationHelper,
                                                   fcmToken: fcmToken)
        let viewController = NotificationInputViewController(notiObject: notiObject,
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
        viewController.requestNotificationHandler = viewModel.makeRequestNotification(priceType:uuid:formStyle:)
                
        viewController.setUpdateConfigureHanlder = viewModel.configureNotificationInputView(notiObject:style:)
        viewModel.updateNotificationInputViewHandler = viewController.updateNotificationInputView
        return viewController
    }
    
    private func makeSetViewController() -> SetViewController {
        return SetViewController()
    }
}
