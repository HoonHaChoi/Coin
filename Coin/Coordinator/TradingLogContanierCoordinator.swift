//
//  TradingLogContanierCoordinator.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/12.
//

import UIKit

final class TradingLogContanierCoordinator: Coordinator {
    
    let navigationController: UINavigationController
    
    struct Dependency {
        let tradingLogContainerViewControllerFactory: () -> TradingLogContanierViewController
    }
    
    private let tradingLogContainerViewController: TradingLogContanierViewController
    
    init(navigation: UINavigationController = UINavigationController(),
         dependency: Dependency) {
        self.navigationController = navigation
        self.tradingLogContainerViewController = dependency.tradingLogContainerViewControllerFactory()
    }
    
    func start() {
        navigationController.tabBarItem = UITabBarItem(title: "일지", image: UIImage(named: "Does"), selectedImage: UIImage(systemName: ""))
        navigationController.pushViewController(tradingLogContainerViewController, animated: true)
    }
    
}
