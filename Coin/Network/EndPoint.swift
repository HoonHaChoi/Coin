//
//  EndPoint.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/03.
//

import Foundation

enum Endpoint {
    
    private static let scheme = "http"
    private static let host = "34.64.77.122"
    private static let port = 8080
    
    static func searchURL(keyword: String) -> URL? {
        var component = URLComponents()
        component.scheme = scheme
        component.host = host
        component.port = port
        component.path = "/api/v1/tickers"
        component.queryItems = [
            URLQueryItem(name: "search", value: keyword),
            URLQueryItem(name: "market", value: "krw")
        ]
        return component.url
    }
    
    static func exchangeURL(market: Exchange) -> URL? {
        var component = URLComponents()
        component.scheme = scheme
        component.host = host
        component.port = port
        component.path = "/api/v1/tickers"
        component.queryItems = [
            URLQueryItem(name: "market", value: "krw"),
            URLQueryItem(name: "exchange", value: market.toString),
        ]
        return component.url
    }
    
    static func interestURL(uuidURL: String) -> URL? {
        var component = URLComponents()
        component.scheme = scheme
        component.host = host
        component.port = port
        component.path = "/api/v1/tickers/\(uuidURL)"
        return component.url
    }
    
    static var socketURL: URL? {
        var component = URLComponents()
        component.scheme = scheme
        component.host = host
        component.port = port
        component.path = "/socket"
        return component.url
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
