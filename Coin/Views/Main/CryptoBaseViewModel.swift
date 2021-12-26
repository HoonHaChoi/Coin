//
//  CryptoViewModel.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/27.
//

import Foundation
import Combine

class CryptoBaseViewModel: BaseViewModel {
    
    private(set) var socketUseCase: SocketUseCase
    
    var coinsHandler: (([Coin]) -> Void)?
    var errorHandler: ((NetworkError) -> Void)?
    var metaHandler: (([CoinMeta]) -> Void)?
    
    init(service: NetworkService, socketUsecase : SocketUseCase) {
        self.socketUseCase = socketUsecase
        super.init(service: service)
    }
}
