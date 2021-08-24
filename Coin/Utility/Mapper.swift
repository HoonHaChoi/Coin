//
//  Mapper.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/25.
//

import Foundation

struct EnumMapper<key: Hashable, item> where key: Sequence {

    private let map: [key: item]
    
    init(key: [key], item: [item]) {
        self.map = Dictionary(uniqueKeysWithValues: zip(key, item))
    }
    
    subscript(key: key) -> item? {
        return map[key]
    }
}
