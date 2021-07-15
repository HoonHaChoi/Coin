//
//  MainCoordinator.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/13.
//

import UIKit

final class MainCoordinator: Coordinator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController: ViewController = UIStoryboard.init(name: "Main", bundle: nil)
            .instantiateViewController(identifier: "ViewController") { coder in
                return ViewController(coder: coder)
            }
        viewController.coordinator = self
        
        navigationController.pushViewController(viewController, animated: true)
    }
}
