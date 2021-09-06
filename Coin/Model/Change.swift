//
//  Change.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/07.
//

import UIKit

enum Change: String, Codable, CustomStringConvertible, CaseIterable {
    case fall = "FALL"
    case even = "EVEN"
    case rise = "RISE"
    
    static func selectType(_ state: String) -> Self {
        if state == "FALL" {
            return .fall
        } else if state == "RISE" {
            return .rise
        } else{
            return .even
        }
    }
    
    var description: String {
        self.rawValue
    }
    
    func signString() -> String {
        let mapper = EnumMapper(key: Change.allCases,
                                          item: ["-","","+"])
        return mapper[self] ?? ""
    }
    
    func matchColor() -> UIColor {
        let mapper = EnumMapper(key: Change.allCases,
                                      item: [UIColor.fallColor,
                                             UIColor.basicColor,
                                             UIColor.riseColor])
        return mapper[self] ?? .basicColor
    }
}
