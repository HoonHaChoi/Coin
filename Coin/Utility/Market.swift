//
//  Market.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/11.
//

import Foundation

enum Market {
    case fall
    case even
    case rise
    
    var state: String {
        switch self {
        case .even:
            return "EVEN"
        case .fall:
            return "FALL"
        case .rise:
            return "RISE"
        }
    }
    
    static func selectType(_ state: String) -> Self {
        if state == "FALL" {
            return .fall
        } else if state == "RISE" {
            return .rise
        } else{
            return .even
        }
    }
}
