//
//  CryptoHeaderView.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/26.
//

import UIKit

class CryptoHeaderView: UITableViewHeaderFooterView {

    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib = UINib(nibName: identifier, bundle: nil)

}
