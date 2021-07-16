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
    
    func configure(coin: Coin, imageLoader: Loader) {
        coinName.text = coin.koreanName
        imageLoad(loader: imageLoader, to: coin.logo)
    }
    
    private func imageLoad(loader: Loader, to logoURL: String) {
        cancell = loader.load(urlString: logoURL)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] uiImage in
                self?.coinImageView.image = uiImage
            }
    }
}
