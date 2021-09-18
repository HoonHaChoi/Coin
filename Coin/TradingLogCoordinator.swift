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
    }

    private let tradingLogViewController: TradingLogViewController
    
    init(navigation: UINavigationController = UINavigationController(),
         dependency: Dependency) {
        self.navigationController = navigation
        self.tradingLogViewController = dependency.tradingLogViewControllerFactory()
    }
    
    func start() {
        navigationController.pushViewController(tradingLogViewController, animated: true)
    }
}
