//
//  UserSetting.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/11.
//

import Foundation

protocol UserSettingFetching {
    func fetchAscendingBool() -> Bool
}

protocol UserSettingChangeable {
    func changeAsceding()
}

struct UserSetting: UserSettingFetching, UserSettingChangeable {
    private let defaults: UserDefaults
    private let ascendingKey = "ascending"
    
    init() {
        defaults = .standard
    }
    
    func changeAsceding() {
        let ascending = defaults.bool(forKey: ascendingKey) ? false : true
        defaults.set(ascending, forKey: ascendingKey)
    }
    
    func fetchAscendingBool() -> Bool {
        return defaults.bool(forKey: ascendingKey)
    }
}
