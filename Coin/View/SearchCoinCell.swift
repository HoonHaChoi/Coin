//
//  SearchCoinCell.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/11.
//

import UIKit
import Combine

class SearchCoinCell: UITableViewCell {

    @IBOutlet weak var coinImageView: UIImageView!
    @IBOutlet weak var coinName: UILabel!
    private var cancell: AnyCancellable?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(coin: Coin) {
        cancell = ImageLoader().load(urlString: coin.logo).receive(on: DispatchQueue.main).sink { [weak self] uiimage in
            self?.coinImageView.image = uiimage
        }
        coinName.text = coin.koreanName
    }
}
