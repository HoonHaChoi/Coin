//
//  SearchViewCoordinator.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/30.
//

import UIKit

final class SearchCoordinator: Coordinator {
    
    let navigationController: UINavigationController
    
    struct Dependency {
        let searchViewControllerFactory: (SearchStyle) -> SearchViewController
        let notificationIntputViewControllerFactory: (NotificationObject, NotificationInputFormStyle) -> NotificationInputViewController
    }
    
    private let searchViewController: SearchViewController
    private let notificationIntputViewController: (NotificationObject, NotificationInputFormStyle) -> NotificationInputViewController
    
    init(navigation: UINavigationController,
         dependency: Dependency,
         searchStyle: SearchStyle) {
        self.navigationController = navigation
        self.searchViewController = dependency.searchViewControllerFactory(searchStyle)
        self.notificationIntputViewController = dependency.notificationIntputViewControllerFactory
    }
    
    func start() {
        searchViewController.coordinator = self
        navigationController.pushViewController(searchViewController, animated: true)
    }
    
    func showNotificationInputViewController(uuid: String) {
        let notiObject = NotificationObject.create(uuid)
        let notificationInputCoordinator = NotificationInputCoordinator(
            navigation: navigationController,
            dependency: .init(notificationInputViewFactory: notificationIntputViewController),
            notificationObject: notiObject,
            formStyle: .create)
        coordinate(to: notificationInputCoordinator)
    }
    
}
