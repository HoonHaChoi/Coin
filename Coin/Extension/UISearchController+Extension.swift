//
//  UISearchController+Extension.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/17.
//

import UIKit
import Combine

extension UISearchController {
    var textFieldPublisher: AnyPublisher<String, Never> {
        return self.searchBar.searchTextField.searchTextPublisher
    }
}

