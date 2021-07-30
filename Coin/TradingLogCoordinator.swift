//
//  TradingLogCoordinator.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/31.
//

import UIKit

final class TradingLogCoordinator: Coordinator {
    let navigationController: UINavigationController
    
    init(navigation: UINavigationController = UINavigationController()) {
        self.navigationController = navigation
    }
    
    func start() {
        navigationController.tabBarItem = UITabBarItem(title: "일지", image: UIImage(), selectedImage: UIImage())
    }
}
