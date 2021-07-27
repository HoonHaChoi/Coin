//
//  MainViewModel.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/27.
//

import Foundation

class MainViewModel {
    
    private let socketUseCase: SocketUseCase
    
    init(usecase: SocketUseCase) {
        self.socketUseCase = usecase
    }
    
    func fetchSocketCoins() {
        socketUseCase.requestSocketCoins { (result: Result<[Coin], NetworkError>) in
            
        }
            
    }
}
