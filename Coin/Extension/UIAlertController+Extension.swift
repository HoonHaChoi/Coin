//
//  UIAlertController+Extension.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/09.
//

import UIKit

extension UIAlertController {
    
    convenience init(action: ((UIAlertAction) -> Void)?) {
        self.init(title: "삭제", message: "해당 일지를 삭제하시겠습니까?", preferredStyle: .alert)
        addAction(UIAlertAction(title: "확인", style: .default, handler: action))
        addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
    }
    
    convenience init(title: String, message: String) {
        self.init(title: title, message: message, preferredStyle: .alert)
        addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
    }
    
    convenience init(message: String, action: ((UIAlertAction) -> Void)?) {
        self.init(title: "", message: message, preferredStyle: .alert)
        addAction(UIAlertAction(title: "확인", style: .default, handler: action))
    }
    
    func deleteNotifiationAlert(action: ((UIAlertAction) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(message: "알림을 삭제 하시겠습니까?", action: action)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: action))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        return alert
    }
}
