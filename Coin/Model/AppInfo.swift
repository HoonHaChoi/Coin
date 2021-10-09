//
//  AppInfo.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/10/10.
//

import Foundation

struct AppInfo: Decodable {
    let results: [AppInfoResult]
}
struct AppInfoResult: Decodable {
    let version: String
}
