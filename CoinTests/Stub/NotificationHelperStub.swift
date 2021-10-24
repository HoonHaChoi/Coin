//
//  NotificationHelperStub.swift
//  CoinTests
//
//  Created by HOONHA CHOI on 2021/10/23.
//

import Foundation

final class NotificationHelperStub: NotificationHelp {
    
    func mapping(typeName: String) -> String {
        return typeName
    }
    
    func mapping(cycleName: String) -> String {
        return cycleName
    }
    
    func findTypeIndex(type: String) -> Int {
        return 0
    }
}
