//
//  SetCoordinator.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/22.
//

import UIKit

final class SetCoordinator: Coordinator {
    
    let navigationController: UINavigationController
    
    struct Dependency {
        let setViewControllerFactory: () -> SetViewController
    }

    private let setViewController: SetViewController
    
    init(navigation: UINavigationController = .init(),
         dependency: Dependency) {
        self.navigationController =  navigation
        self.setViewController = dependency.setViewControllerFactory()
    }
    
    func start() {
        setViewController.title = "설정"
        navigationController.tabBarItem = UITabBarItem(title: "설정", image: UIImage(systemName: "gearshape"), selectedImage: UIImage(systemName: "gearshape.fill"))
        navigationController.pushViewController(setViewController, animated: true)
    }
}


