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
        let searchViewControllerFactory: () -> SearchViewController
    }
    
    private let searchViewController: SearchViewController
    
    init(navigation: UINavigationController,
         dependency: Dependency) {
        self.navigationController = navigation
        self.searchViewController = dependency.searchViewControllerFactory()
    }
    
    func start() {
        searchViewController.title = "관심 코인 설정"
        navigationController.pushViewController(searchViewController, animated: true)
    }
}
