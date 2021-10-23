//
//  UIView+Extension.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/10/23.
//

import UIKit

extension UIView {
    func setChangeColor(change: Change) -> UIColor {
        let mapper = EnumMapper(key: Change.allCases,
                                      item: [UIColor.fallColor,
                                             UIColor.basicColor,
                                             UIColor.riseColor])
        return mapper[change] ?? .basicColor
    }
}

