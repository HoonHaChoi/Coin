import Foundation

struct Coin: Codable {
    let uuid: String
    let exchange: Exchange
    let ticker: String
    let market: String
    let koreanName, englishName: String
    let meta: Meta
    let logo: String
}

enum Exchange: String, Codable {
    case upbit = "UPBIT"
}

struct Meta: Codable {
    let openingPrice, highPrice, lowPrice, tradePrice: String
    let changePrice, changeRate, accTradePrice24H: String
    let change: Change
}

enum Change: String, Codable {
    case fall = "FALL"
    case even = "EVEN"
    case rise = "RISE"
}
