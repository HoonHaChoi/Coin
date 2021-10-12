//
//  EndPoint.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/03.
//

import Foundation

enum Endpoint {
    
    private static let scheme = "http"
    //private static let host = "coil.koreacentral.cloudapp.azure.com"
    //private static let host = "coil-api.eba-fvgkzjcp.ap-northeast-2.elasticbeanstalk.com"
    private static let host = "codex.iptime.org"
    private static let port: Int? = 38080
    private static let tickersPath = "/api/v1/tickers"
    private static let notificationPath = "/api/v1/notifications/"
    private static let chart = "/chart"
    private static let socket = "/socket"
    
    static func searchURL(keyword: String, exchange: String) -> URL? {
        var component = URLComponents()
        component.scheme = scheme
        component.host = host
        component.port = port
        component.path = tickersPath
        component.queryItems = [
            URLQueryItem(name: "search", value: keyword),
            URLQueryItem(name: "market", value: "krw"),
            URLQueryItem(name: "exchange", value: exchange)
        ]
        return component.url
    }
    
    static func exchangeURL(market: Exchange) -> URL? {
        var component = URLComponents()
        component.scheme = scheme
        component.host = host
        component.port = port
        component.path = tickersPath
        component.queryItems = [
            URLQueryItem(name: "market", value: "krw"),
            URLQueryItem(name: "exchange", value: market.toString),
        ]
        return component.url
    }
    
    static func favoriteURL(uuid: String) -> URL? {
        var component = URLComponents()
        component.scheme = scheme
        component.host = host
        component.port = port
        component.path = tickersPath+"/\(uuid)"
        return component.url
    }
    
    static func chartURL(uuid: String) -> URL? {
        var component = URLComponents()
        component.scheme = scheme
        component.host = host
        component.port = port
        component.path = tickersPath+"/\(uuid)"+chart
        return component.url
    }
    
    static func notificationsURL(token: String) -> URL? {
        var component = URLComponents()
        component.scheme = scheme
        component.host = host
        component.port = port
        component.path = notificationPath+"\(token)"
        return component.url
    }
    
    static func notificationSwitchURL(uuid: String) -> URL? {
        var component = URLComponents()
        component.scheme = scheme
        component.host = host
        component.port = port
        component.path = notificationPath+"\(uuid)"+"/active"
        return component.url
    }
    
    static func notificationCreateURL(token: String) -> URL? {
        var component = URLComponents()
        component.scheme = scheme
        component.host = host
        component.port = port
        component.path = notificationPath+"\(token)"+"/tickers"
        return component.url
    }
    
    static func notificationCycleURL() -> URL? {
        var component = URLComponents()
        component.scheme = scheme
        component.host = host
        component.port = port
        component.path = notificationPath+"cycles"
        return component.url
    }
    
    static var socketURL: URL? {
        var component = URLComponents()
        component.scheme = scheme
        component.host = host
        component.port = port
        component.path = socket
        return component.url
    }
    
    static func appStoreURL(bundle: String) -> URL? {
        return URL(string: "https://itunes.apple.com/lookup?bundleId=\(bundle)")
    }
    
    static func baseNotificationURL(path: String) -> URL? {
        var component = URLComponents()
        component.scheme = scheme
        component.host = host
        component.port = port
        component.path = notificationPath + path
        return component.url
    }
    
    static func notificationURL(type: NotificationURLType) -> URL? {
        return baseNotificationURL(path: type.path)
    }
}

// 다시 수정되어 사용할지 모르니 주석처리

//enum URLRouter {
//    case search(String)
//    case socket
//}
//
//protocol URLGenerator {
//    func url(path: URLRouter) -> URL?
//}
//
//struct EndPoint: URLGenerator {
//
//    func url(path: URLRouter) -> URL? {
//        switch path {
//        case .search(let keyword):
//            return searchURL(keyword: keyword )
//        case .socket:
//            return socketURL
//        }
//    }
//
//    private let scheme = "http"
//    private let host = "34.64.77.122"
//    private let port = 8080
//
//    private func searchURL(keyword: String) -> URL? {
//        var component = URLComponents()
//        component.scheme = scheme
//        component.host = host
//        component.port = port
//        component.path = "/api/v1/tickers"
//        component.queryItems = [
//            URLQueryItem(name: "search", value: keyword),
//            URLQueryItem(name: "market", value: "krw")
//        ]
//        return component.url
//    }
//
//    private var socketURL: URL? {
//        var component = URLComponents()
//        component.scheme = scheme
//        component.host = host
//        component.port = port
//        component.path = "/socket"
//        return component.url
//    }
//}
