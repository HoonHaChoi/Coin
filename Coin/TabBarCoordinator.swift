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
        
        let marketNavigationController = UINavigationController()
        marketNavigationController.tabBarItem = UITabBarItem(title: "시세", image: UIImage(named: ""), selectedImage: UIImage())
        let marketCoordinator = MainCoordinator(navigationController: marketNavigationController)
        
        tabBarController.viewControllers = [marketNavigationController]
        tabBarController.modalPresentationStyle = .fullScreen
        navigationController.setViewControllers([tabBarController], animated: true)
        coordinate(to: marketCoordinator)
    }
}
