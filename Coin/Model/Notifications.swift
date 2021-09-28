//
//  Notifications.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/15.
//

import Foundation

struct Notification: Decodable {
    let id: Int
    let uuid: String
    let exchange: String
    let ticker: String
    let market: String
    let englishName: String
    var logo: String?
    var notifications: [Notifications]
}

struct Notifications: Decodable {
    let uuid: String
    let basePrice: String
    let type: String
    var lastNotificationData: String?
    let isActived: Bool
    let notificationCycle: NotificationCycle
}

struct NotificationCycle: Decodable {
    let uuid: String
    let displayCycle: String
}
