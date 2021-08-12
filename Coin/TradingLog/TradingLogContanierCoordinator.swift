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
        
    }
    
    init(navigation: UINavigationController = UINavigationController(),
         dependency: Dependency) {
        self.navigationController = navigation
    }
    
    func start() {
        navigationController.tabBarItem = UITabBarItem(title: "일지", image: UIImage(), selectedImage: UIImage())
    }
    
}
