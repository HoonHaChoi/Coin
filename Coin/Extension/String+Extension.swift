//
//  String+Extension.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/18.
//

import Foundation

extension String {
    func convertPriceKRW() -> String {
        let convertNSNumber = NSNumber(value: Double(self) ?? 0.0)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 1
        return numberFormatter.string(from: convertNSNumber) ?? ""
    }
    
    func convertPercentRate() -> String {
        let rate = (Double(self) ?? 0.0) * 100
        return String(format: "%.2f",  rate) + "%"
    }
    
    func convertDate() -> Date {
        let dateFormat = DateFormatter()
        return dateFormat.convertStringToDate(dateString: self)
    }
}
