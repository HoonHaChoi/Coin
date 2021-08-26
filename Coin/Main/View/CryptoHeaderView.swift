//
//  CryptoHeaderView.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/26.
//

import UIKit

protocol CryptoHeaderViewDelegate {
    func didNameSortAction()
    func didCurrentPriceSortAction()
    func didChangeSortAction()
}

class CryptoHeaderView: UITableViewHeaderFooterView {

    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib = UINib(nibName: identifier, bundle: nil)

    var delegate: CryptoHeaderViewDelegate?
    
    @IBOutlet weak var nameSortButton: UIButton!
    @IBOutlet weak var currentPriceSortButton: UIButton!
    @IBOutlet weak var changeSortButton: UIButton!
    
    @IBOutlet var sortButtons: [UIButton]!
    
    @IBAction func nameSortButtonTapped(_ sender: UIButton) {
        delegate?.didNameSortAction()
        changeButtonState(sender: sender)
        changeButtonImage(sender: sender)
    }
    
    @IBAction func currentPriceSortButtonTapped(_ sender: UIButton) {
        delegate?.didCurrentPriceSortAction()
        changeButtonState(sender: sender)
        changeButtonImage(sender: sender)
    }
    
    @IBAction func changeSortButtonTapped(_ sender: UIButton) {
        delegate?.didChangeSortAction()
        changeButtonState(sender: sender)
        changeButtonImage(sender: sender)
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
    
    private func changeButtonImage(sender: UIButton) {
        if sender.currentImage == UIImage(systemName: "arrow.up") {
            sender.setImage(UIImage(systemName: "arrow.down"), for: .normal)
        } else {
            sender.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        }
    }
    
}
