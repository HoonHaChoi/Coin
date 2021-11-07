//
//  DateManagerTest.swift
//  CoinTests
//
//  Created by HOONHA CHOI on 2021/11/07.
//
import Foundation

class DateManagerStub: DateManagerProtocol {
    
    var isSuccess: Bool
    
    init(succeeState: Bool) {
        isSuccess = succeeState
    }
    
    func currentDateString() -> String {
        return ""
    }
    
    func turnOfBackward() {}
    
    func turnOfForward() {}
    
    func calculateMonthStartOfEnd() -> (start: Date, end: Date) {
        return (start: .init(), end: .init())
    }
    
    func confirmNextMonth() -> Bool {
        return isSuccess
    }
    
    func confirmPreviousMonth() -> Bool {
        return isSuccess
    }
}
