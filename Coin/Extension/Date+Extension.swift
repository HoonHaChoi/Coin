//
//  Date+Extension.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/06.
//

import Foundation

extension Date {
    func convertString() -> String {
        let dateFormat = DateFormatter()
        return dateFormat.convertDateToString(date: self)
    }
    
    func removeTimeStamp() -> Date {
        guard let date = Calendar.current.date(
                from: Calendar.current.dateComponents([.year,.month,.day], from: self)) else {
            return Date()
        }
        return date
    }
}
