//
//  EndPoint.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/03.
//

import Foundation

enum URLRouter {
    case search
    case socket
}

protocol URLGenerator {
    func url(path: URLRouter, keyword: String?) -> URL?
}

struct EndPoint: URLGenerator {
    
    func url(path: URLRouter, keyword: String? = nil) -> URL? {
        switch path {
        case .search:
            return searchURL(keyword: keyword ?? "")
        case .socket:
            return socketURL
        }
    }
    
    private let scheme = "http"
    private let host = "34.64.77.122"
    private let port = 8080
    
    private func searchURL(keyword: String) -> URL? {
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
    
    private var socketURL: URL? {
        var component = URLComponents()
        component.scheme = scheme
        component.host = host
        component.port = port
        component.path = "/socket"
        return component.url
    }
}
