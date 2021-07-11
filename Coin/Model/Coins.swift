import Foundation

struct Coin: Codable {
    let uuid: String
    let exchange: Exchange
    let ticker: String
    let market: Market
    let koreanName, englishName: String
    let meta: Meta
    let logo: String
}

enum Exchange: String, Codable {
    case upbit = "UPBIT"
}

enum Market: String, Codable {
    case btc = "BTC"
    case krw = "KRW"
    case usdt = "USDT"
}

struct Meta: Codable {
    let openingPrice, highPrice, lowPrice, tradePrice: String
    let changePrice, changeRate, accTradePrice24H: String
}
