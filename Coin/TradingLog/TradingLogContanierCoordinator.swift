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
        let tradingLogViewControllerFactory: () -> TradingLogViewController
    }
    
    private let tradingLogContainerViewController: TradingLogContanierViewController
    private let tradingLogViewController: TradingLogViewController
    
    init(navigation: UINavigationController = UINavigationController(),
         dependency: Dependency) {
        self.navigationController = navigation
        self.tradingLogContainerViewController = dependency.tradingLogContainerViewControllerFactory()
        self.tradingLogViewController = dependency.tradingLogViewControllerFactory()
    }
    
    func start() {
        navigationController.tabBarItem = UITabBarItem(title: "일지", image: UIImage(), selectedImage: UIImage())
        
    }
    
}
