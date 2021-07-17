//
//  EndPoint.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/03.
//

import Foundation

enum EndPoint {
    static func searchURL(keyword: String) -> URL? {
        var component = URLComponents()
        component.scheme = "http"
        component.host = "34.64.77.122"
        component.port = 8080
        component.path = "/api/v1/tickers"
        component.queryItems = [
            URLQueryItem(name: "search", value: keyword),
            URLQueryItem(name: "market", value: "krw")
        ]
        return component.url
    }
}
