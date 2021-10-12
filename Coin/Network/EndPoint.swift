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
    private static let tickersPath = "/api/v1/tickers/"
    private static let notificationPath = "/api/v1/notifications/"
    private static let socket = "/socket"
    
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
    
    private static func basetickersURL(path: String,
                                       queryItems: [URLQueryItem]? = nil) -> URL? {
        var component = URLComponents()
        component.scheme = scheme
        component.host = host
        component.port = port
        component.path = tickersPath + path
        component.queryItems = queryItems
        return component.url
    }
    
    static func tickerURL(type: TickerURLType) -> URL? {
        switch type {
        case .search(_, _):
            return basetickersURL(path: type.path, queryItems: type.queryItem)
        case .exchange(_):
            return basetickersURL(path: type.path, queryItems: type.queryItem)
        case .favorite(_), .chart(_):
            return basetickersURL(path: type.path)
        }
    }
    
    private static func baseNotificationURL(path: String) -> URL? {
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
