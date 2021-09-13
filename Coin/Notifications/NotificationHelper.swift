//
//  NotificationHelper.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/13.
//

import Foundation

struct NotificationHelper {
       
    private(set) var notificationTypeNames = ["상승","하락"]
    private(set) var notificationType = ["up","down"]
    
    private(set) var cycleNames = [
        "1분 간격으로 알림",
        "5분 간격으로 알림",
        "10분 간격으로 알림",
        "30분 간격으로 알림",
        "1시간 간격으로 알림"
    ]
    
    private(set) var cycleUUIDs = [
        "eb337599-8c4f-4dc8-8c95-9e6e84054259",
        "2d01f98e-ca62-4d10-a0bc-8880abadb2a3",
        "a1057597-4460-4f1a-b45d-4fd4248fadbb",
        "8b8bc4b7-15a5-422b-976c-69dc4a14b7b0",
        "33b7553c-fbcc-48a5-b1be-291cfcc3f029"
    ]
    
    private(set) lazy var typeMapper = EnumMapper(key: notificationTypeNames, item: notificationType)
    private(set) lazy var cycleMapper = EnumMapper(key: cycleNames, item: cycleUUIDs)
    
    mutating func mapping(typeName: String) -> String {
        guard let map = self.typeMapper[typeName] else {
            return ""
        }
        return map
    }
    
    mutating func mapping(cycleName: String) -> String {
        guard let map = self.cycleMapper[cycleName] else {
            return ""
        }
        return map
    }
}

