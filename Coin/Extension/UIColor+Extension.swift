//
//  UIColor+Extension.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/11.
//

import UIKit

extension UIColor {
    
    // MARK: ProFitBackgroundColor
    static var fallColor: UIColor {
        return UIColor(named: "FALLColor") ?? .init()
    }
    static var riseColor: UIColor {
        return UIColor(named: "RISEColor") ?? .init()
    }
    
    // MARK: FontColor
    static var basicColor: UIColor {
        return UIColor(named: "191919") ?? .init()
    }
    static var middleGrayColor: UIColor {
        return UIColor(named: "767676") ?? .init()
    }
    static var weakGrayColor: UIColor {
        return UIColor(named: "999999") ?? .init()
    }
    
    // MARK: ViewBackgroundColor
    static var DEDEDE: UIColor {
        return UIColor(named: "DEDEDE") ?? .init()
    }
    
    static var EDEDED: UIColor {
        return UIColor(named: "EDEDED") ?? .init()
    }
    
    static var statsBackground: UIColor {
        return UIColor(named: "StatsBackground") ?? .init()
    }
    
    static var basicBackground: UIColor {
        return UIColor(named: "BasicBackground") ?? .init()
    }
}
