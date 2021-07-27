//
//  MainCoordinator.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/13.
//

import UIKit

final class MainCoordinator: Coordinator {
    private let navigationController: UINavigationController
    
    struct Dependency {
        let mainViewControllerFactory: () -> MainViewController
        let searchViewControllerFactory: () -> SearchViewController
    }
    
    private let mainViewController: MainViewController
    private let searchViewController: SearchViewController
    
    init(navigationController: UINavigationController = UINavigationController(),
         dependency: Dependency) {
        self.navigationController = navigationController
        self.mainViewController = dependency.mainViewControllerFactory()
        self.searchViewController = dependency.searchViewControllerFactory()
    }
    
    func start() {
        let imageLoader = ImageLoader()
        let mainDataSource = MainDataSourece(imageLoader: imageLoader)
        let endpoint = EndPoint()
        let socket = Socket(url: endpoint.url(path: .socket)!)
        let socketRepository = SocketRepository(socket: socket)
        let mainViewModel = MainViewModel(usecase: socketRepository)
        let viewController = MainViewController.instantiate { coder in
            return MainViewController(coder: coder,
                                  dataSource: mainDataSource)
        }
        
        mainViewModel.errorHandler = viewController.showError
        mainViewModel.coinListHandler = viewController.updateCoinList
        viewController.fetchCoinsHandler = mainViewModel.fetchCoins
        
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
