//
//  DateManager.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/03.
//

import Foundation

struct DateManager {
    
    private let currentDate: Date
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
    
    func turnOfBackward(date: Date) -> Date {
        guard let date = calendar.date(byAdding: .month, value: -1, to: date) else {
            return .init()
        }
        return date
    }
    
    func turnOfForward(date: Date) -> Date {
        guard let date = calendar.date(byAdding: .month, value: +1, to: date) else {
            return .init()
        }
        return date
    }
    
    func confirmCurrentMonth() -> Bool {
        if turnOfForward(date: currentDate) > Date() {
            return true
        }
        return false
    }
}
