//
//  NotificationsCoordinator.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/08.
//

import UIKit

final class NotificationsCoordinator: Coordinator {
    
    let navigation: UINavigationController
    
    struct Dependency {
        let notificationsViewControllerFactory: () -> NotificationsViewController
    }
    
    private let notificationsViewController: NotificationsViewController
    
    init(navigation: UINavigationController = UINavigationController(),
         dependency: Dependency {
         self.navigation = navigation
         self.notificationsViewController = dependency.notificationsViewControllerFactory()
         }
    )
    
    func start() {
        navigation.title = "알림"
        navigation.pushViewController(notificationsViewController, animated: true)
    }
}
