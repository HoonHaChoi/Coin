//
//  UITableViewCell+Extension.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/11.
//

import UIKit

extension UITableViewCell {
    static var identifer: String {
        return String(describing: self)
    }
    
    static var nib = UINib(nibName: identifer, bundle: nil)
}
