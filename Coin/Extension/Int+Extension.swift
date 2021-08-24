//
//  Int+Extension.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/16.
//

import Foundation

extension Int {
    func convertPriceKRW() -> String {
        let convertNSNumber = NSNumber(value: self)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return (numberFormatter.string(from: convertNSNumber) ?? "0") + "원"
    }
}

extension Int: Sequence{
    public func makeIterator() -> CountableRange<Int>.Iterator {
            return (0..<self).makeIterator()
    }
}
