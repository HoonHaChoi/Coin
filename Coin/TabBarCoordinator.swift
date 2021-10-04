//
//  TabBarCoordinator.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/13.
//

import UIKit

final class TabBarCoordinator: Coordinator {
    let navigationController: UINavigationController
    
    struct Dependency {
        let mainCoordinatorFactory: () -> MainCoordinator
        let tradingLogCoordinatorFactory: () -> TradingLogContanierCoordinator
        let notificationCoordinatorFactory: () -> NotificationsCoordinator
        let setCoordinatorFactory: () -> SetCoordinator
    }
    
    private let mainCoordinator: MainCoordinator
    private let tradingLogCoordinator: TradingLogContanierCoordinator
    private let notificationsCoordinator: NotificationsCoordinator
    private let setCoordinator: SetCoordinator
    
    init(navigationController: UINavigationController,
         dependency: Dependency) {
        self.navigationController = navigationController
        self.mainCoordinator = dependency.mainCoordinatorFactory()
        self.tradingLogCoordinator = dependency.tradingLogCoordinatorFactory()
        self.notificationsCoordinator = dependency.notificationCoordinatorFactory()
        self.setCoordinator = dependency.setCoordinatorFactory()
    }
    
    func start() {
        let tabBarController = UITabBarController()
        
        tabBarController.viewControllers = [mainCoordinator.navigationController,
                                            tradingLogCoordinator.navigationController,
                                            notificationsCoordinator.navigationController,
                                            setCoordinator.navigationController]
//        tabBarController.modalPresentationStyle = .fullScreen
        navigationController.setViewControllers([tabBarController], animated: false)
        coordinate(to: mainCoordinator)
        coordinate(to: tradingLogCoordinator)
        coordinate(to: notificationsCoordinator)
        coordinate(to: setCoordinator)
    }
}
