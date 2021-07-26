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
        let imageLoader = ImageLoader()
        let mainDataSource = MainDataSourece(imageLoader: imageLoader)
        let viewController = MainViewController.instantiate { coder in
            return MainViewController(coder: coder,
                                  imageLoader: imageLoader,
                                  dataSource: mainDataSource)
        }
        viewController.coordinator = self
        viewController.navigationItem.backButtonTitle = ""
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showSearchViewController() {
        let endpoint = EndPoint()
        let viewModel = SearchViewModel(endpoint: endpoint)
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
