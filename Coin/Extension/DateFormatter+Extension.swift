//
//  DateFormatter+Extension.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/06.
//

import Foundation

extension DateFormatter {
    
    func convertDateToString(date: Date) -> String {
        self.dateFormat = "yyyy년 MM월 dd일"
        return self.string(from: date)
    }
    
    func convertStringToDate(dateString: String) -> Date {
        self.dateFormat = "yyyy년 MM월 dd일"
        return self.date(from: dateString) ?? Date()
    }
}
