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
        let viewController = ViewController.instantiate { coder in
            return ViewController(coder: coder)
        }
        viewController.coordinator = self
        viewController.navigationItem.backButtonTitle = ""
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showSearchViewController() {
        let viewModel = SearchViewModel()
        let imageLoader = ImageLoader()
        let searchDataSourece = SearchCoinDataSource(imageLoader: imageLoader)
        
        let searchViewController = SearchViewController.instantiate { coder in
            return SearchViewController(coder: coder,
                                        viewModel: viewModel,
                                        dataSource: searchDataSourece)
        }
        
        viewModel.coinsHandler = searchViewController.updateSearchResult
        searchViewController.keywordHandler = viewModel.fetchSearchCoins(keyword:)
        
        searchViewController.title = "검색"
        navigationController.pushViewController(searchViewController,
                                                animated: true)
    }
}
