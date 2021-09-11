//
//  NotificationsCoordinator.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/08.
//

import UIKit

final class NotificationsCoordinator: Coordinator {
    
    let navigationController: UINavigationController
    
    struct Dependency {
        let notificationsViewControllerFactory: () -> NotificationsViewController
        let searchViewControllerFactory: (SearchStyle) -> SearchViewController
    }
    
    private let notificationsViewController: NotificationsViewController
    private let searchViewController: (SearchStyle) -> SearchViewController
    
    init(navigation: UINavigationController = UINavigationController(),
         dependency: Dependency) {
         self.navigationController = navigation
         self.notificationsViewController = dependency.notificationsViewControllerFactory()
        self.searchViewController = dependency.searchViewControllerFactory
    }
    
    func start() {
        notificationsViewController.title = "알림"
        navigationController.tabBarItem = UITabBarItem(title: "알림", image: UIImage(), selectedImage: UIImage())
        notificationsViewController.coordinator = self
        navigationController.pushViewController(notificationsViewController, animated: true)
    }
    
    func showSearchViewController(style: SearchStyle) {
        let searchCoordinator = SearchCoordinator(navigation: navigationController,
                                                  dependency: .init(searchViewControllerFactory: searchViewController),
                                                  searchStyle: style)
        coordinate(to: searchCoordinator)
    }
}
