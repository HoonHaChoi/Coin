//
//  UITableViewCell+Extension.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/11.
//

import UIKit

extension UITableViewCell: CellReusable {
    
    func updateBackgroundAnimation(change: Change) {
        UIView.animate(withDuration: 0.2) {
            switch change {
            case .even:
                break
            case .fall:
                self.backgroundColor = .fallColor.withAlphaComponent(0.2)
            case .rise:
                self.backgroundColor = .riseColor.withAlphaComponent(0.2)
            }
        } completion: { _ in
            self.backgroundColor = .systemBackground
        }
    }
}
