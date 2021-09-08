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
    }
    
    private let notificationsViewController: NotificationsViewController
    
    init(navigation: UINavigationController = UINavigationController(),
         dependency: Dependency) {
         self.navigationController = navigation
         self.notificationsViewController = dependency.notificationsViewControllerFactory()
    }
    
    func start() {
        notificationsViewController.title = "알림"
        navigationController.tabBarItem = UITabBarItem(title: "알림", image: UIImage(), selectedImage: UIImage())
        navigationController.pushViewController(notificationsViewController, animated: true)
    }
}
