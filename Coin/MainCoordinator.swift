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
        let detailViewControllerFactory: (Coin) -> DetailViewController
    }
    
    private let searchViewController: () -> SearchViewController
    private let mainContainerViewController: MainContainerViewController
    private let detailViewController: (Coin) -> DetailViewController
    
    
    init(navigationController: UINavigationController = UINavigationController(),
         dependency: Dependency) {
        self.navigationController = navigationController
        self.searchViewController = dependency.searchViewControllerFactory
        self.mainContainerViewController = dependency.mainContainerViewControllerFactory()
        self.detailViewController = dependency.detailViewControllerFactory
    }
    
    func start() {
        mainContainerViewController.navigationItem.backButtonTitle = ""
        mainContainerViewController.coordinator = self
        navigationController.tabBarItem = UITabBarItem(title: "시세", image: UIImage(), selectedImage: UIImage())
        navigationController.pushViewController(mainContainerViewController, animated: true)
    }
    
    func showSearchViewController() {
        let searchCoordinator = SearchCoordinator(navigation: navigationController,
                                                  dependency: .init(searchViewControllerFactory: searchViewController))
        coordinate(to: searchCoordinator)
    }
    
    func showDetailViewController(from coin: Coin) {
        navigationController.pushViewController(detailViewController(coin),
                                                animated: true)
    }
}
