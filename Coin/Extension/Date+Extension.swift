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
}
