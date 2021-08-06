//
//  UITextField+Extension.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/06.
//

import UIKit
import Combine

extension UITextField {
    
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification,
                                             object: self)
            .map { ($0.object as? UITextField)?.text ?? "" }
            .eraseToAnyPublisher()
    }
}
