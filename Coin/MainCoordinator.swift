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
        let mainContainerViewControllerFactory: () -> MainContainerViewController
        let searchViewControllerFactory: () -> SearchViewController
    }
    
    private let searchViewController: SearchViewController
    private let mainContainerViewController: MainContainerViewController
    
    init(navigationController: UINavigationController = UINavigationController(),
         dependency: Dependency) {
        self.navigationController = navigationController
        self.searchViewController = dependency.searchViewControllerFactory()
        self.mainContainerViewController = dependency.mainContainerViewControllerFactory()
    }
    
    func start() {
        mainContainerViewController.navigationItem.backButtonTitle = ""
        navigationController.tabBarItem = UITabBarItem(title: "시세", image: UIImage(), selectedImage: UIImage())
        navigationController.pushViewController(mainContainerViewController, animated: true)
    }
    
    func showSearchViewController() {
        searchViewController.title = "검색"
        navigationController.pushViewController(searchViewController,
                                                animated: true)
    }
}
