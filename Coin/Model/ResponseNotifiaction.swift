//
//  ResponseNotifiaction.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/12/26.
//

import Foundation

struct ResponseNotifiaction: Decodable {
    let uuid: String
    let type: String
    let basePrice: String
    let deviceToken: String
    let notificationBaseDate: String
    let isActived: Bool
}
