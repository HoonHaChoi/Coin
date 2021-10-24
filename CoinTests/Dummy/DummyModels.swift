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
        let coin: Coin = .init(uuid: "uuid", exchange: .upbit, ticker: "ticker",
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
        for i in 0...3 {
            let notificationCycle: NotificationCycle = .init(uuid: "fakeUUID"+"\(i)", displayCycle: "fakeDisplayCycle"+"\(i)")
            notificationCycles.append(notificationCycle)
        }
        
        return notificationCycles
    }
}
