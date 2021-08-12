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
    }
    
    private let mainCoordinator: MainCoordinator
    private let tradingLogCoordinator: TradingLogContanierCoordinator
    
    init(navigationController: UINavigationController,
         dependency: Dependency) {
        self.navigationController = navigationController
        self.mainCoordinator = dependency.mainCoordinatorFactory()
        self.tradingLogCoordinator = dependency.tradingLogCoordinatorFactory()
    }
    
    func start() {
        let tabBarController = UITabBarController()
        
        tabBarController.viewControllers = [mainCoordinator.navigationController,
                                            tradingLogCoordinator.navigationController]
        tabBarController.modalPresentationStyle = .fullScreen
        navigationController.setViewControllers([tabBarController], animated: true)
        
        coordinate(to: mainCoordinator)
        coordinate(to: tradingLogCoordinator)
    }
}
