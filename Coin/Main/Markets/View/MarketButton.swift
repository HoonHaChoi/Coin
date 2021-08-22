//
//  MarketButton.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/22.
//

import UIKit

final class MarketButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override var intrinsicContentSize: CGSize {
        let baseSize = super.intrinsicContentSize
        return CGSize(width: baseSize.width + 20, height: baseSize.height)
    }
    
    private func configure() {
        layer.cornerRadius = 10
        self.setTitleColor(.weakGrayColor, for: .normal)
        self.setTitleColor(.basicColor, for: .selected)
        self.backgroundColor = .statsBackground
    }
}
