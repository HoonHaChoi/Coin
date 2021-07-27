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
    }
    
    private let mainCoordinator: MainCoordinator
    
    init(navigationController: UINavigationController,
         dependency: Dependency) {
        self.navigationController = navigationController
        self.mainCoordinator = dependency.mainCoordinatorFactory()
    }
    
    func start() {
        let tabBarController = UITabBarController()
        
        tabBarController.viewControllers = [mainCoordinator.navigationController]
        tabBarController.modalPresentationStyle = .fullScreen
        navigationController.setViewControllers([tabBarController], animated: true)
        
        coordinate(to: mainCoordinator)
    }
}
