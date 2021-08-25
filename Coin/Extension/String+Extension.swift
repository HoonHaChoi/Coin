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
        numberFormatter.maximumFractionDigits = 2
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
    
    func limitTextCount() -> String {
        let matchNumber = matchStringNumber()
        return matchNumber.count < 11 ? matchNumber.convertPriceKRW() : "9999999999".convertPriceKRW()
    }
    
    func convertRegexInt() -> Int {
        return Int(matchStringNumber()) ?? 0
    }
    
    private func matchStringNumber() -> String {
        let regex = try? NSRegularExpression(pattern: "[0-9]")
        let results = regex?.matches(in: self,
                                    range: NSRange(self.startIndex..., in: self))
        let result = results?.compactMap {
            String(self[Range($0.range, in: self)!])
        }.filter { $0 != "" } ?? []
        return result.joined()
    }
}
