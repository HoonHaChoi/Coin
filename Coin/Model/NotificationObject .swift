//
//  NotificationObject .swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/13.
//

import Foundation

struct NotificationObject: Encodable {
    
    static var create: ((String) -> Self) = { uuid in
        Self(type: "", basePrice: 0, tickerUUID: uuid, notificationCycleUUID: "")
    }
    
    let type: String
    let basePrice: Int
    let tickerUUID: String?
    let notificationCycleUUID: String
}
