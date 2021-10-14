import Foundation

struct Coin: Codable {
    let uuid: String
    let exchange: Exchange
    let ticker: String
    let market: String
    let englishName: String
    var meta: Meta
    let logo: String?
}

struct Meta: Codable {
    let tradePrice, changePrice, changeRate, accTradePrice24H: String
    let change: Change
}

enum Exchange: String, CaseIterable ,Codable {
    case upbit = "UPBIT"
    case bithumb = "BITHUMB"
    case coinone = "COINONE"

    var title: String {
        return self.rawValue.lowercased()
    }
}

extension Coin: Equatable {
    static func == (lhs: Coin, rhs: Coin) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
