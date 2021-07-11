//
//  CellReusable.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/12.
//

import Foundation

protocol CellReusable {
    static var reuseIdentifier: String { get }
    static var nibName: String { get }
}

extension CellReusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    static var nibName: String {
        return String(describing: self)
    }
}
