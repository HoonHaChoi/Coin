//
//  DayOfWeek.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/11.
//

import Foundation

enum DayOfWeek: Int, CustomStringConvertible {
    case sun = 1
    case mon
    case tue
    case wed
    case thur
    case fir
    case sat
    
    var description: String {
        switch self {
        case .sun:
            return "(일)"
        case .mon:
            return "(월)"
        case .tue:
            return "(화)"
        case .wed:
            return "(수)"
        case .thur:
            return "(목)"
        case .fir:
            return "(금)"
        case .sat:
            return "(토)"
        }
    }
}
