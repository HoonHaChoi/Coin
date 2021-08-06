//
//  UITextView+Extension.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/06.
//

import UIKit
import Combine

extension UITextView {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextView.textDidChangeNotification,
                                             object: self)
            .map { ($0.object as? UITextView)?.text ?? "" }
            .eraseToAnyPublisher()
    }
}
