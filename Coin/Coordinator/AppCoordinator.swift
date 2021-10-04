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
        let splashViewFactory: () -> SplashViewController
    }
    
    private let tabBarCoordinator: TabBarCoordinator
    private let splashViewController: SplashViewController
    
    init(navigationController: UINavigationController,
        dependency: Dependency) {
        self.navigation = navigationController
        self.splashViewController = dependency.splashViewFactory()
        self.tabBarCoordinator = dependency.tabBarCoordinatorFactory(navigation)
    }
    
    func start() {
        splashViewController.coordinator = self
        navigation.setViewControllers([splashViewController], animated: true)
    }
    
    func showMainCoordinator() {
        coordinate(to: tabBarCoordinator)
    }
}
