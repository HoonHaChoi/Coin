//
//  DateManager.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/03.
//

import Foundation

final class DateManager {
    
    private var currentDate: Date
    private let calendar: Calendar
    private let dateFormattor: DateFormatter
    
    init() {
        self.currentDate = Date()
        self.calendar = Calendar.current
        self.dateFormattor = DateFormatter()
    }
    
    func currentDateString() -> String {
        dateFormattor.dateFormat = "yyyy.mm"
        return dateFormattor.string(from: currentDate)
    }
    
    private func turnOfBackward() -> Date {
        guard let date = calendar.date(byAdding: .month, value: -1, to: currentDate) else {
            return .init()
        }
        return date
    }
    
    private func turnOfForward() -> Date {
        guard let date = calendar.date(byAdding: .month, value: +1, to: currentDate) else {
            return currentDate
        }
        return date
    }
    
    func calculateMonthStartOfEnd() -> (start: Date, end: Date) {
        guard let month = calendar.dateInterval(of: .month, for: currentDate) else {
            return (.init() , .init())
        }
        return (start: month.start, end: month.end)
    }
    
    func confirmNextMonth() -> Bool {
        if Date() < turnOfForward() {
            return true
        }
        self.currentDate = turnOfForward()
        return false
    }
    
    func confirmPreviousMonth  () -> Bool {
        if currentDate < calendar.date(byAdding: .year, value: -10, to: Date())! {
            return true
        }
        self.currentDate = turnOfBackward()
        return false
    }
}
