//
//  SetCoordinator.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/22.
//

import UIKit

final class SetCoordinator: Coordinator {
    
    let navigation: UINavigationController
    
    struct Dependency {
        let setViewControllerFactory: () -> SetViewController
    }

    private let setViewController: SetViewController
    
    init(navigation: UINavigationController = .init(),
         dependency: Dependency) {
        self.navigation =  navigation
        self.setViewController = dependency.setViewControllerFactory()
    }
    
    func start() {
        setViewController.title = "설정"
        navigation.tabBarItem = UITabBarItem(title: "설정", image: UIImage(systemName: "gearshape"), selectedImage: UIImage(systemName: "gearshape.fill"))
        navigation.pushViewController(setViewController, animated: true)
    }
}


