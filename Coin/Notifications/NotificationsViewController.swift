//
//  NotificationsViewController.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/08.
//

import UIKit

class NotificationsViewController: UIViewController {

    private lazy var addNotificationCryptoButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        button.tintColor = .basicColor
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = addNotificationCryptoButton
    }
}
