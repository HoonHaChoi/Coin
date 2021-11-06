//
//  FakeAddEnvironment.swift
//  CoinTests
//
//  Created by HOONHA CHOI on 2021/11/07.
//

import Foundation
import Combine

struct FakeAddEnvironment {
    
    var isSuccess: Bool
    
    init(isSuccessState: Bool) {
        isSuccess = isSuccessState
    }
    
    func fakeExistDate(date: Date) -> Bool {
        return isSuccess
    }
    
    func fakeFindLog(date: Date) -> TradingLogMO? {
        return nil
    }
}
