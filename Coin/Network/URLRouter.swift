//
//  URLRouter.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/10/12.
//

import Foundation


// MARK: Notification Router
enum NotificationURLType {
    case list(String)
    case Switch(String)
    case create(String)
    case cycle
    
    var path: String {
        switch self {
        case let .list(token):
            return token
        case let .Switch(uuid):
            return uuid + "/active"
        case let .create(token):
            return token + "/tickers"
        case .cycle:
            return "cycles"
        }
    }
    
}
