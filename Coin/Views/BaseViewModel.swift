//
//  BaseViewModel.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/12/26.
//

import Foundation
import Combine

class BaseViewModel {
    
    private(set) var service: NetworkService
    var cancellable: Set<AnyCancellable>
    
    init(service: NetworkService) {
        self.service = service
        cancellable = .init()
    }
}
