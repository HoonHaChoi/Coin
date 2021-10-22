//
//  BaseSpy.swift
//  CoinTests
//
//  Created by HOONHA CHOI on 2021/10/22.
//

import Foundation

class BaseSpy {
    
    let dummyModel: DummyModels
    var isSuccess: Bool
    
    init(isSuccess: Bool) {
        self.dummyModel = .init()
        self.isSuccess = isSuccess
    }
}
