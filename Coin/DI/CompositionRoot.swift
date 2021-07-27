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
    
    lazy var socket = Socket(url: endpoint.url(path: .socket))
    lazy var socketRepository = SocketRepository(socket: socket)
    
    func makeTabBarCoordinator(navigation: UINavigationController) -> TabBarCoordinator {
        return TabBarCoordinator(navigationController: navigation)
    }
    
    func makeMainCoordinator(navigation: UINavigationController) -> MainCoordinator {
        return MainCoordinator()
    }
       
}

extension AppDependency: MainCoordinatorDependencies {
    mutating func makeMainController() -> MainViewController {
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
    
    
}
