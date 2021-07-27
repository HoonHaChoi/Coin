//
//  MainViewModel.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/27.
//

import Foundation

class MainViewModel {
    
    private let socketUseCase: SocketUseCase
    
    var errorHandler: ((NetworkError) ->Void)?
    var coinListHandler: (([Coin]) -> Void)?
    
    init(usecase: SocketUseCase) {
        self.socketUseCase = usecase
    }
    
    func fetchCoins() {
        socketUseCase.requestSocketCoins { [weak self] (result: Result<[Coin], NetworkError>) in
            switch result {
            case .success(let coins):
                self?.coinListHandler?(coins)
            case .failure(let error):
                self?.errorHandler?(error)
            }
        }
    }
}
