//
//  FakeModel.swift
//  CoinTests
//
//  Created by HOONHA CHOI on 2021/10/21.
//

import Foundation

struct DummyModels {
    
    func createDummyCoin() -> Coin {
        let meta: Meta = .init(tradePrice: "0", changePrice: "0",
                               changeRate: "0%", accTradePrice24H: "", change: .even)
        let coin: Coin = .init(uuid: "fakeUUID", exchange: .upbit, ticker: "fakeTicker",
                               market: "krw", englishName: "fakeName", meta: meta, logo: nil)
        return coin
    }
    
    func createDummyNotice() -> Notice {
        let fakeNotificationCycle: NotificationCycle = .init(uuid: "fakeUUID",
                                                             displayCycle: "fakeDisplayCycle")
        
        let fakeNotifications: Notifications = .init(uuid: "fakeNotifications", basePrice: "100", type: "up", lastNotificationData: nil, isActived: true, notificationCycle: fakeNotificationCycle)
        
        return .init(id: 0, uuid: "fakeUUID", exchange: "fakeExchange",
                     ticker: "fakeTicker", market: "fakeMarket",
                     englishName: "fakeName", logo: nil, notifications: [fakeNotifications])
    }
    
    func createDummyNotificationCycle() -> [NotificationCycle] {
        
        var notificationCycles: [NotificationCycle] = .init()
        for i in 0...7 {
            let notificationCycle: NotificationCycle = .init(uuid: "fakeCycleUUID"+"\(i)", displayCycle: "fakeDisplayCycle"+"\(i)")
            notificationCycles.append(notificationCycle)
        }
        
        return notificationCycles
    }
    
    func createDummyAppInfo() -> AppInfo {
        return AppInfo.init(results: [AppInfoResult.init(version: "0")])
    }
    
    func makeDummyFactory<T: Decodable>(type: T.Type) -> T {
        if T.self == [Coin].self {
            return [createDummyCoin()] as! T
        } else if T.self == Coin.self {
            return createDummyCoin() as! T
        } else if T.self == [Notice].self {
            return [createDummyNotice()] as! T
        } else if T.self == AppInfo.self {
            return createDummyAppInfo() as! T
        } else if T.self == NotificationCycle.self {
            return createDummyNotificationCycle() as! T
        } else {
            return String.self as! T
        }
    }
}
