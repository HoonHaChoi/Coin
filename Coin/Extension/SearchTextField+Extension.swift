//
//  SearchTextField+Extension.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/17.
//

import UIKit
import Combine

extension UITextField {
    var searchTextPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UISearchTextField }
            .map { $0.text ?? "" }
            .eraseToAnyPublisher()
    }
}
