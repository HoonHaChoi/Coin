//
//  CoinList.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/03.
//

import Foundation

struct Coins: Codable {
    let uuid: String
    let exchange: Exchange
    let ticker: String
    let market: Market
    let koreanName, englishName: String
    let meta: Meta

    enum CodingKeys: String, CodingKey {
        case uuid, exchange, ticker, market
        case koreanName = "korean_name"
        case englishName = "english_name"
        case meta
    }
}

enum Exchange: String, Codable {
    case upbit = "UPBIT"
}

enum Market: String, Codable {
    case btc = "BTC"
    case krw = "KRW"
    case usdt = "USDT"
}

// MARK: - Meta
struct Meta: Codable {
    let openingPrice, highPrice, lowPrice, tradePrice: String
    let changePrice, changeRate, accTradePrice24H: String

    enum CodingKeys: String, CodingKey {
        case openingPrice = "opening_price"
        case highPrice = "high_price"
        case lowPrice = "low_price"
        case tradePrice = "trade_price"
        case changePrice = "change_price"
        case changeRate = "change_rate"
        case accTradePrice24H = "acc_trade_price_24h"
    }
}
