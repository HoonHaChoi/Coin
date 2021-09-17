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
        let notificationInputViewFactory: (NotificationObject, NotificationInputFormStyle) -> NotificationInputViewController
    }
    
    private let notificationInputView: NotificationInputViewController
    
    init(navigation: UINavigationController,
         dependency: Dependency,
         notificationObject: NotificationObject,
         formStyle: NotificationInputFormStyle) {
        self.navigationController = navigation
        self.notificationInputView = dependency.notificationInputViewFactory(notificationObject,formStyle)
    }
    
    func start() {
        navigationController.pushViewController(notificationInputView, animated: true)
    }
}
