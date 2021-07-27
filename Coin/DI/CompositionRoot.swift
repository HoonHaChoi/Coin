//
//  CompositionRoot.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/28.
//

import UIKit

struct AppDependency {
    
    let imageLoader = ImageLoader()
    let endpoint = EndPoint()
    let socket = Socket(url: Endpoint2.socketURL)
    
    func makeTabBarCoordinator(navigation: UINavigationController) -> TabBarCoordinator {
        return TabBarCoordinator(navigationController: navigation,
                                 dependency:
                                    .init(mainCoordinatorFactory: makeMainCoordinator))
    }
    
    func makeMainCoordinator() -> MainCoordinator {
        return MainCoordinator(dependency:
                                .init(mainViewControllerFactory: makeMainController,
                                      searchViewControllerFactory: makeSearchViewController))
    }
}

extension AppDependency {
    func makeMainController() -> MainViewController {
        let socketRepository = SocketRepository(socket: socket)
        let mainDataSource = MainDataSourece(imageLoader: imageLoader)
        let mainViewModel = MainViewModel(usecase: socketRepository)
        let mainViewController = MainViewController.instantiate { coder in
            return MainViewController(coder: coder,
                                      dataSource: mainDataSource)
        }
        
        mainViewModel.errorHandler = mainViewController.showError
        mainViewModel.coinListHandler = mainViewController.updateCoinList
        mainViewController.fetchCoinsHandler = mainViewModel.fetchCoins
        
        return mainViewController
    }
    
    func makeSearchViewController() -> SearchViewController {
        let viewModel = SearchViewModel(endpoint: endpoint)
        let searchDataSourece = SearchCoinDataSource(imageLoader: imageLoader)
        let searchViewController = SearchViewController.instantiate { coder in
            return SearchViewController(coder: coder,
                                        viewModel: viewModel,
                                        dataSource: searchDataSourece)
        }
        
        viewModel.coinsHandler = searchViewController.updateSearchResult
        searchViewController.keywordHandler = viewModel.fetchSearchCoins(keyword:)
        
        searchViewController.title = "검색"
        return searchViewController
    }
}
