//
//  Double+Extensionm.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/16.
//

import Foundation

extension Double {
    func convertRateString() -> String {
        if self.isFinite {
            return String(format: "%.1f", self)+"%"
        }
        return "0.0%"
    }
}
