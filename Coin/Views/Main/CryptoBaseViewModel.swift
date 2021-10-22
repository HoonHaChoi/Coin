//
//  CryptoViewModel.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/27.
//

import Foundation
import Combine

class CryptoBaseViewModel {
    
    let service: FavortieService
    let socketUseCase: SocketUseCase
    var cancell: AnyCancellable?
    
    var coinsHandler: (([Coin]) -> Void)?
    var failErrorHandler: ((NetworkError) -> Void)?
    var metaHandler: (([CoinMeta]) -> Void)?
    
    init(service: FavortieService,
         socketUsecase : SocketUseCase) {
        self.service = service
        self.socketUseCase = socketUsecase
    }
}
