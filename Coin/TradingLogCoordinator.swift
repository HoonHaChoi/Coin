//
//  TradingLogCoordinator.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/31.
//

import UIKit

final class TradingLogCoordinator: Coordinator {
    let navigationController: UINavigationController
    
    struct Dependency {
        let tradingLogViewControllerFactory: () -> TradingLogViewController
        let tradingLogAddViewControllerFactory: () -> TradingLogAddViewController
    }

    private let tradingLogViewController: TradingLogViewController
    private let tradingLogAddViewController: () -> TradingLogAddViewController
    
    init(navigation: UINavigationController = UINavigationController(),
         dependency: Dependency) {
        self.navigationController = navigation
        self.tradingLogViewController = dependency.tradingLogViewControllerFactory()
        self.tradingLogAddViewController = dependency.tradingLogAddViewControllerFactory
    }
    
    func start() {
        navigationController.tabBarItem = UITabBarItem(title: "일지", image: UIImage(), selectedImage: UIImage())
        tradingLogViewController.coordinator = self
        navigationController.pushViewController(tradingLogViewController, animated: true)
    }
    
    func addTradingLogTapped() {
        let tradingLogAddViewController: TradingLogAddViewController = tradingLogAddViewController()
        
        navigationController.pushViewController(tradingLogAddViewController, animated: true)
    }
}
