//
//  SearchCoinCell.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/11.
//

import UIKit
import Combine

protocol FavoriteButtonTappedDelegate: AnyObject {
    func didFavoriteButtonTapped(cell: SearchCoinCell)
}

class SearchCoinCell: UITableViewCell {

    @IBOutlet weak var coinImageView: UIImageView!
    @IBOutlet weak var coinName: UILabel!
    @IBOutlet weak var market: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    private var cancell: AnyCancellable?
    weak var delegate: FavoriteButtonTappedDelegate?
    
    func configure(coin: Coin, imageLoader: Loader, state: Bool) {
        coinName.text = coin.ticker
        imageLoad(loader: imageLoader, to: coin.logo)
        market.text = "\(coin.exchange.toString.capitalized)/\(coin.market)"
        favoriteButton.isSelected = state
        updateButtonColor()
    }
    
    private func imageLoad(loader: Loader, to logoURL: String?) {
        cancell = loader.load(urlString: logoURL)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] uiImage in
                self?.coinImageView.image = uiImage
            }
    }
    
    private func updateButtonColor() {
        favoriteButton.tintColor =  favoriteButton.isSelected ? .riseColor : .basicColor
    }
    
    func searchStyle(style: SearchStyle) {
        switch style {
        case .favorite:
            break
        case .notification:
            favoriteButton.isHidden = true
        }
    }
    
    @IBAction func didFavoriteButtonTapped(_ sender: Any) {
        delegate?.didFavoriteButtonTapped(cell: self)
    }
}
