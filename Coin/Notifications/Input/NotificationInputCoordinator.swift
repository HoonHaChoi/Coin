//
//  NotificationInputCoordinator.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/11.
//

import UIKit

final class NotificationInputCoordinator: Coordinator {
    
    let navigationController: UINavigationController
    
    struct Dependency {
        let notificationInputViewFactory: (String) -> NotificationInputViewController
    }
    
    private let notificationInputView: NotificationInputViewController
    
    init(navigation: UINavigationController,
         dependency: Dependency,
         uuid: String) {
        self.navigationController = navigation
        self.notificationInputView = dependency.notificationInputViewFactory(uuid)
    }
    
    func start() {
        navigationController.pushViewController(notificationInputView, animated: true)
    }
}
