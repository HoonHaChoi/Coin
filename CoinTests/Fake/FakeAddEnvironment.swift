//
//  FakeAddEnvironment.swift
//  CoinTests
//
//  Created by HOONHA CHOI on 2021/11/07.
//

import UIKit
import Combine

struct FakeAddEnvironment {
    var subject: PassthroughSubject<TradingLog, Never>
    var findLog: (Date) -> TradingLogMO?
    var existDate: (Date) -> Bool
    var alert: UIAlertController

    init() {
        subject = .init()
        alert = .init()
        findLog = fakeFindLog
        existDate = fakeExistDate
    }
    
    var fakeExistDate: (Date) -> Bool = { _ in
        return false
    }
    
    var fakeFindLog: (Date) -> TradingLogMO? = { _ in
        return nil
    }
}
