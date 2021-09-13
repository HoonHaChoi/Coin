//
//  NotificationCompleteButton.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/13.
//

import UIKit

class NotificationCompleteButton: UIButton {

    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                backgroundColor = .fallColor.withAlphaComponent(1.0)
            } else {
                backgroundColor = .fallColor.withAlphaComponent(0.3)
            }
        }
    }
}
