//
//  Int64+Extension.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/11.
//

import Foundation

extension Int64 {
    func convertPriceKRW() -> String {
        let convertNSNumber = NSNumber(value: Double(self))
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: convertNSNumber)!+"원"
    }
}
