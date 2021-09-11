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
    }
    
    private let searchViewController: SearchViewController
    
    init(navigation: UINavigationController,
         dependency: Dependency,
         searchStyle: SearchStyle) {
        self.navigationController = navigation
        self.searchViewController = dependency.searchViewControllerFactory(searchStyle)
    }
    
    func start() {
        navigationController.pushViewController(searchViewController, animated: true)
    }
}
