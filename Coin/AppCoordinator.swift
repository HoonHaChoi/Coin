//
//  AppCoordinator.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/13.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    let navigation: UINavigationController
    
    struct Dependency {
        let tabBarCoordinatorFactory: (UINavigationController) -> TabBarCoordinator
    }
    
    private let tabBarCoordinator: TabBarCoordinator
    
    init(navigationController: UINavigationController,
        dependency: Dependency) {
        self.navigation = navigationController
        self.tabBarCoordinator = dependency.tabBarCoordinatorFactory(navigation)
    }
    
    func start() {
        coordinate(to: tabBarCoordinator)
    }
}
