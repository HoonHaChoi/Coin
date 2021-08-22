//
//  MarketButton.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/22.
//

import UIKit

protocol MarketButtonTapDelegate {
    func passCurrentTitle(to title: String)
}

final class MarketButton: UIButton {
    
    private var delegate: MarketButtonTapDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
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
        self.addTarget(self, action: #selector(buttonTapAction(_:)), for: .touchUpInside)
    }
    
    @objc private func buttonTapAction(_ sender: UIButton) {
        delegate?.passCurrentTitle(to: currentTitle ?? "")
    }
}
