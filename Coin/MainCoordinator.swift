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
    
    private let searchViewController: () -> SearchViewController
    private let mainContainerViewController: MainContainerViewController
    
    
    
    init(navigationController: UINavigationController = UINavigationController(),
         dependency: Dependency) {
        self.navigationController = navigationController
        self.searchViewController = dependency.searchViewControllerFactory
        self.mainContainerViewController = dependency.mainContainerViewControllerFactory()
    }
    
    func start() {
        mainContainerViewController.navigationItem.backButtonTitle = ""
        mainContainerViewController.coodinator = self
        navigationController.tabBarItem = UITabBarItem(title: "시세", image: UIImage(), selectedImage: UIImage())
        navigationController.pushViewController(mainContainerViewController, animated: true)
    }
    
    func showSearchViewController() {
        let searchCoordinator = SearchCoordinator(navigation: navigationController,
                                                  dependency: .init(searchViewControllerFactory: searchViewController))
        coordinate(to: searchCoordinator)
    }
}
