//
//  CryptoViewModel.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/27.
//

import Foundation
import Combine

class CryptoBaseViewModel {
    
    let searchUseCase: SearchUseCase
    let socketUseCase: SocketUseCase
    var cancell: AnyCancellable?
    
    var coinsHandler: (([Coin]) -> Void)?
    var failErrorHandler: ((NetworkError) -> Void)?
    var metaHandler: (([CoinMeta]) -> Void)?
    
    init(searchUsecase: SearchUseCase = NetworkManager(),
         socketUsecase : SocketUseCase) {
        self.searchUseCase = searchUsecase
        self.socketUseCase = socketUsecase
    }
    
    func disConnectSocket() {
        socketUseCase.onDisConnect()
    }
}
