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

// MARK: Ticker Router
enum TickerURLType {
    case search(String,String)
    case exchange(String)
    case favorite(String)
    case chart(String)
    
    var path: String {
        switch self {
        case .search(_, _):
            return ""
        case .exchange(_):
            return ""
        case let .favorite(uuid):
            return uuid
        case let .chart(uuid):
            return uuid + "/chart"
        }
    }
    
    var queryItem: [URLQueryItem]? {
        switch self {
        case let .search(keyword, exchange):
            return [
                URLQueryItem(name: "search", value: keyword),
                URLQueryItem(name: "market", value: "krw"),
                URLQueryItem(name: "exchange", value: exchange)
            ]
        case let .exchange(exchange):
            return [
                URLQueryItem(name: "market", value: "krw"),
                URLQueryItem(name: "exchange", value: exchange),
            ]
        default:
            return nil
        }
    }
}

