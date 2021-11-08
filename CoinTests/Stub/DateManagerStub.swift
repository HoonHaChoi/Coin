//
//  DateManagerTest.swift
//  CoinTests
//
//  Created by HOONHA CHOI on 2021/11/07.
//
import Foundation

class DateManagerStub: DateManagerProtocol {
    
    var isSuccess: Bool
    var dateString: String
    
    init(succeeState: Bool) {
        isSuccess = succeeState
        dateString = ""
    }
    
    func currentDateString() -> String {
        return dateString
    }
    
    func turnOfBackward() {
        dateString = "Move Backward"
    }
    
    func turnOfForward() {
        dateString = "Move Forward"
    }
    
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
