//
//  URLRouter.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/10/12.
//

import Foundation


// MARK: Notification Router
enum NotificationURLType {
    case api(String)
    case active(String)
    case create(String)
    case cycle
    
    var path: String {
        switch self {
        case let .api(token):
            return token
        case let .active(uuid):
            return uuid + "/active"
        case let .create(token):
            return token + "/tickers"
        case .cycle:
            return "cycles"
        }
    }
    
}
