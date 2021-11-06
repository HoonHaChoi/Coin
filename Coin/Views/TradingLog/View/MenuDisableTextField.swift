//
//  MenuDisableTextField.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/18.
//

import UIKit

class MenuDisableTextField: UITextField {
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        []
    }
    
}
