//
//  NotificationObject .swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/13.
//

import Foundation

struct NotificationObject: Encodable {
    let type: String
    let basePrice: Int
    let tickerUUID: String?
    let notificationCycleUUID: String
}
