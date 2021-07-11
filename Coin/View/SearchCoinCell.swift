//
//  SearchCoinCell.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/11.
//

import UIKit

class SearchCoinCell: UITableViewCell {

    @IBOutlet weak var coinImageView: UIImageView!
    @IBOutlet weak var coinName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(coin: Coin) {
        coinName.text = coin.koreanName
    }
}
