//
//  NotificationHelperStub.swift
//  CoinTests
//
//  Created by HOONHA CHOI on 2021/10/23.
//

import Foundation

final class NotificationHelperStub: NotificationHelp {
    
    var dummyPriceTypeDic = ["dummyPriceType1": "fakeUp"]
    var dummyCycleUUIDDic = ["dummyCycleName1": "fakeCycleUUID"]
    
    func mapping(typeName: String) -> String {
        return dummyPriceTypeDic[typeName] ?? ""
    }
    
    func mapping(cycleName: String) -> String {
        return dummyCycleUUIDDic[cycleName] ?? ""
    }
    
    func findTypeIndex(type: String) -> Int {
        return 0
    }
}
