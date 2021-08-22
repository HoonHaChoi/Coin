//
//  MarketButtons.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/22.
//

import UIKit

final class MarketButtonsStackView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        self.axis = .horizontal
        self.alignment = .fill
        self.distribution = .fill
        self.translatesAutoresizingMaskIntoConstraints = false
        self.spacing = 8
    }
    
}


