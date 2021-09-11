//
//  NotificationInputViewModel.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/10.
//

import Foundation
import Combine

enum NotificationInputType {
    case basePrice
    case cycle
}

final class NotificationInputViewModel {
    
    private var basePriceText: String
    private var cycleText: String
    private let searchUseCase: SearchUseCase
    private var cancell: AnyCancellable?
    
    init(usecase: SearchUseCase) {
        basePriceText = ""
        cycleText = ""
        self.searchUseCase = usecase
    }
    
    var isValidCheckHandler: ((Bool) -> ())?
    var coinHandler: ((Coin) -> Void)?
    var errorHandler: ((NetworkError) -> Void)?
    
    func fetchSearchCoin(uuid: String) {
        cancell = searchUseCase.requestFavoriteCoins(uuidString: uuid)
            .sink { [weak self] (fail) in
                if case .failure(let error) = fail {
                    self?.errorHandler?(error)
                }
            } receiveValue: { [weak self] (coin) in
                self?.coinHandler?(coin)
            }
    }
    
    func update(text: String, type: NotificationInputType) {
        switch type {
        case .basePrice:
            basePriceText = text
        case .cycle:
            cycleText = text
        }
        isValidCheckHandler?(isFormValidCheck())
    }
    
    func isFormValidCheck() -> Bool {
        return !basePriceText.isEmpty &&
            !cycleText.isEmpty
    }
}


