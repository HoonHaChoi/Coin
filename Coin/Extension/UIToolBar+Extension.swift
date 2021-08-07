//
//  UIToolBar+Extension.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/07.
//

import UIKit

extension UIToolbar {
    
    convenience init(width: CGFloat, leftAction: Selector, rightAction: Selector) {
        self.init(frame: CGRect(x: .zero, y: .zero, width: width, height: 44))
        let cancellButton = UIBarButtonItem(title: "취소", style: .plain, target: nil, action: leftAction)
        let flexspace = UIBarButtonItem(systemItem: .flexibleSpace)
        let doneButton = UIBarButtonItem(title: "확인", style: .plain, target: nil, action: rightAction)
        setItems([cancellButton,flexspace,doneButton], animated: true)
        cancellButton.tintColor = .systemRed
        setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        backgroundColor = .systemBackground
        sizeToFit()
    }
    
    convenience init(width: CGFloat, cancellAction: Selector) {
        self.init(frame: CGRect(x: .zero, y: .zero, width: width, height: 44))
        let cancellButton = UIBarButtonItem(title: "확인", style: .plain, target: nil, action: cancellAction)
        let middleFlexspace = UIBarButtonItem(systemItem: .flexibleSpace)
        let leftFlexspace = UIBarButtonItem(systemItem: .flexibleSpace)
        setItems([leftFlexspace,middleFlexspace,cancellButton], animated: true)
        cancellButton.tintColor = .systemRed
        setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        backgroundColor = .systemBackground
        sizeToFit()
    }
}
