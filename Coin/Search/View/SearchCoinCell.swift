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
    @IBOutlet weak var market: UILabel!
    private var cancell: AnyCancellable?
    
    func configure(coin: Coin, imageLoader: Loader) {
        coinName.text = coin.ticker
        imageLoad(loader: imageLoader, to: coin.logo)
        market.text = "\(coin.exchange.toString.capitalized)/\(coin.market)"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
       super.setSelected(selected, animated: animated)
       accessoryType = selected ? .checkmark : .none
    }
    
    private func imageLoad(loader: Loader, to logoURL: String?) {
        cancell = loader.load(urlString: logoURL)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] uiImage in
                self?.coinImageView.image = uiImage
            }
    }
}
