//
//  MainCoordinator.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/13.
//

import UIKit

final class MainCoordinator: Coordinator {
    let navigationController: UINavigationController
    
    struct Dependency {
        let mainViewControllerFactory: () -> MainViewController
        let searchViewControllerFactory: () -> SearchViewController
    }
    
    private let mainViewController: MainViewController
    private let searchViewController: SearchViewController
    
    init(navigationController: UINavigationController = UINavigationController(),
         dependency: Dependency) {
        self.navigationController = navigationController
        self.mainViewController = dependency.mainViewControllerFactory()
        self.searchViewController = dependency.searchViewControllerFactory()
    }
    
    func start() {
        mainViewController.coordinator = self
        mainViewController.navigationItem.backButtonTitle = ""
        navigationController.tabBarItem = UITabBarItem(title: "시세", image: UIImage(), selectedImage: UIImage())
        navigationController.pushViewController(mainViewController, animated: true)
    }
    
    func showSearchViewController() {
        searchViewController.title = "검색"
        navigationController.pushViewController(searchViewController,
                                                animated: true)
    }
}
