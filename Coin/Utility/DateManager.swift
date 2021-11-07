//
//  DateManager.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/03.
//

import Foundation

protocol DateManagerProtocol {
    func currentDateString() -> String
    func turnOfBackward()
    func turnOfForward()
    func calculateMonthStartOfEnd() -> (start: Date, end: Date)
    func confirmNextMonth() -> Bool
    func confirmPreviousMonth() -> Bool
}

final class DateManager: DateManagerProtocol {
    
    private(set) var currentDate: Date
    private let calendar: Calendar
    private let dateFormattor: DateFormatter
    
    init() {
        self.currentDate = Date()
        self.calendar = Calendar.current
        self.dateFormattor = DateFormatter()
    }
    
    func currentDateString() -> String {
        dateFormattor.dateFormat = "yyyy.MM"
        return dateFormattor.string(from: currentDate)
    }
    
    func turnOfBackward() {
        guard let date = calendar.date(byAdding: .month, value: -1, to: currentDate) else {
            return
        }
        self.currentDate = date
    }
    
    func turnOfForward() {
        guard let date = calendar.date(byAdding: .month, value: +1, to: currentDate) else {
            return
        }
        self.currentDate = date
    }
    
    func calculateMonthStartOfEnd() -> (start: Date, end: Date) {
        guard let month = calendar.dateInterval(of: .month, for: currentDate) else {
            return (.init() , .init())
        }
        return (start: month.start, end: month.end)
    }
    
    func confirmNextMonth() -> Bool {
        calendar.date(byAdding: .month, value: +1, to: currentDate)! > Date() ? true : false
    }
    
    func confirmPreviousMonth() -> Bool {
        currentDate < calendar.date(byAdding: .year, value: -10, to: Date())! ? true : false
    }
}
