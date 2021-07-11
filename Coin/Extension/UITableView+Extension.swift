//
//  UITableView+Extension.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/12.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(cell: T.Type) {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
}
