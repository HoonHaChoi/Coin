import Foundation

struct Coin: Codable {
    let uuid: String
    let exchange: Exchange
    let ticker: String
    let market: String
    let englishName: String
    let meta: Meta
    let logo: String
}

struct Meta: Codable {
    let tradePrice, changePrice, changeRate, accTradePrice24H: String
    let change: Change
}

enum Exchange: String, CaseIterable ,Codable {
    case upbit = "UPBIT"
    case coinone = "COINONE"
    case bithumb = "BITHUMB"
    
    var toString: String {
        return self.rawValue.lowercased()
    }
}

enum Change: String,CustomStringConvertible, Codable {
    case fall = "FALL"
    case even = "EVEN"
    case rise = "RISE"
    
    static func selectType(_ state: String) -> Self {
        if state == "FALL" {
            return .fall
        } else if state == "RISE" {
            return .rise
        } else{
            return .even
        }
    }
    
    var description: String {
        self.rawValue
    }
}
