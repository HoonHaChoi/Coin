//
//  NotificationsCoordinator.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/08.
//

import UIKit

final class NotificationsCoordinator: NSObject, Coordinator {
    
    let navigationController: UINavigationController
    var childCoordinator: [Coordinator]
    
    struct Dependency {
        let notificationsViewControllerFactory: () -> NotificationsViewController
        let searchViewControllerFactory: (SearchStyle) -> SearchViewController
        let notificationIntputViewControllerFactory: (String, NotificationInputFormStyle) -> NotificationInputViewController
    }
    
    private let notificationsViewController: NotificationsViewController
    private let searchViewController: (SearchStyle) -> SearchViewController
    private let notificationIntputViewController: (String, NotificationInputFormStyle) -> NotificationInputViewController
    
    init(navigation: UINavigationController = UINavigationController(),
         dependency: Dependency) {
        self.navigationController = navigation
        self.notificationsViewController = dependency.notificationsViewControllerFactory()
        self.searchViewController = dependency.searchViewControllerFactory
        self.notificationIntputViewController = dependency.notificationIntputViewControllerFactory
        self.childCoordinator = []
        
    }
    
    func start() {
        navigationController.delegate = self
        notificationsViewController.title = "알림"
        navigationController.tabBarItem = UITabBarItem(title: "알림", image: UIImage(), selectedImage: UIImage())
        notificationsViewController.coordinator = self
        navigationController.pushViewController(notificationsViewController, animated: true)
    }
    
    func showSearchViewController(style: SearchStyle) {
        let searchCoordinator = SearchCoordinator(navigation: navigationController,
                                                  dependency: .init(searchViewControllerFactory: searchViewController, notificationIntputViewControllerFactory: notificationIntputViewController),
                                                  searchStyle: style)
        childCoordinator.append(searchCoordinator)
        coordinate(to: searchCoordinator)
    }

    func showNotificationInputViewController(from notification: NotificationObject) {
        let notificationInputCoordinator = NotificationInputCoordinator(
            navigation: navigationController,
            dependency: .init(notificationInputViewFactory: notificationIntputViewController),
            uuid: "uuid",
            formStyle: .update)
        coordinate(to: notificationInputCoordinator)
    }
    
    private func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinator.enumerated() {
            if coordinator === child {
                childCoordinator.remove(at: index)
                break
            }
        }
    }
    
    private func childDidFinish() {
        childCoordinator.removeAll()
        notificationsViewController.requestNotifications?()
    }
}

extension NotificationsCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        guard let toViewController = navigationController.transitionCoordinator?.viewController(forKey: .to) else {
            return
        }
        
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
    
        if let searchViewController = fromViewController as? SearchViewController  {
            childDidFinish(searchViewController.coordinator)
        }
        
        if let _ = fromViewController as? NotificationInputViewController,
            let _ = toViewController as? NotificationsViewController {
                childDidFinish()
        }
    }
}
