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
        let beforeDay = Calendar.current.date(byAdding: .day, value: -2, to: .init())!
        return (start: beforeDay.removeTimeStamp(), end: .init())
    }
    
    func confirmNextMonth() -> Bool {
        return isSuccess
    }
    
    func confirmPreviousMonth() -> Bool {
        return isSuccess
    }
}
