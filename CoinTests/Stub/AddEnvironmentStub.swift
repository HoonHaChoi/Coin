//
//  FakeAddEnvironment.swift
//  CoinTests
//
//  Created by HOONHA CHOI on 2021/11/07.
//

import Foundation
import Combine

struct AddEnvironmentStub {
    
    var isSuccess: Bool
    var subject: PassthroughSubject<TradingLog, Never>
    
    init(isSuccessState: Bool) {
        isSuccess = isSuccessState
        subject = .init()
    }
    
    func fakeExistDate(date: Date) -> Bool {
        return isSuccess
    }
    
    func fakeFindLog(date: Date) -> TradingLogMO? {
        return nil
    }
}
