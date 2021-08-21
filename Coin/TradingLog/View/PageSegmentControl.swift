//
//  PageSegmentControl.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/21.
//

import UIKit

final class PageSegmentControl: UISegmentedControl {
    
    override init(items: [Any]?) {
        super.init(items: items)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        self.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        self.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        self.selectedSegmentIndex = 0
        self.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.middleGrayColor,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular)
        ], for: .normal)
        self.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.fallColor,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)
        ], for: .selected)
        
    }
}
