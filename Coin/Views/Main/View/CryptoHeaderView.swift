//
//  CryptoHeaderView.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/26.
//

import UIKit

protocol CryptoHeaderViewDelegate: AnyObject {
    func didTickerSortAction(action: PlusMinusAction)
    func didCurrentPriceSortAction(action: PlusMinusAction)
    func didChangeSortAction(action: PlusMinusAction)
}

enum PlusMinusAction {
    case plus
    case minus
}

class CryptoHeaderView: UITableViewHeaderFooterView {

    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib = UINib(nibName: identifier, bundle: nil)

    weak var delegate: CryptoHeaderViewDelegate?
    
    @IBOutlet weak var nameSortButton: UIButton!
    @IBOutlet weak var currentPriceSortButton: UIButton!
    @IBOutlet weak var changeSortButton: UIButton!
    
    @IBOutlet var sortButtons: [UIButton]!
    
    @IBAction func nameSortButtonTapped(_ sender: UIButton) {
        changeButtonState(sender: sender)
        changeButtonImageAndHandler(sender: sender) { action in
            delegate?.didTickerSortAction(action: action)
        }
    }
    
    @IBAction func currentPriceSortButtonTapped(_ sender: UIButton) {
        changeButtonState(sender: sender)
        changeButtonImageAndHandler(sender: sender) { action in
            delegate?.didCurrentPriceSortAction(action: action)
        }
    }
    
    @IBAction func changeSortButtonTapped(_ sender: UIButton) {
        changeButtonState(sender: sender)
        changeButtonImageAndHandler(sender: sender) { action in
            delegate?.didChangeSortAction(action: action)
        }
    }
    
    private func changeButtonState(sender: UIButton) {
        sortButtons.forEach { button in
            if sender == button {
                button.tintColor = .basicColor
                button.setTitleColor(.basicColor, for: .normal)
            } else {
                button.tintColor = .middleGrayColor
                button.setTitleColor(.middleGrayColor, for: .normal)
            }
        }
    }
    
    private func changeButtonImageAndHandler(sender: UIButton,
                                   handler: ((PlusMinusAction) -> ())) {
        if sender.currentImage == UIImage(systemName: "arrow.up") {
            sender.setImage(UIImage(systemName: "arrow.down"), for: .normal)
            handler(.minus)
        } else {
            sender.setImage(UIImage(systemName: "arrow.up"), for: .normal)
            handler(.plus)
        }
    }
    
}
