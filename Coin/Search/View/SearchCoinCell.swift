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
//        updateButton()
    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//       super.setSelected(selected, animated: animated)
//       favoriteButton.tintColor = selected ? .riseColor : .basicColor
//    }
    
    private func imageLoad(loader: Loader, to logoURL: String?) {
        cancell = loader.load(urlString: logoURL)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] uiImage in
                self?.coinImageView.image = uiImage
            }
    }

    //
//    private func updateButton() {
//        if favoriteButton.isSelected {
//            favoriteButton.setImage(.init(systemName: "star.fill"), for: .selected)
//            favoriteButton.tintColor = .systemRed
////            favoriteButton.backgroundColor = .none
//        } else {
//            favoriteButton.setImage(.init(systemName: "star"), for: .selected)
//            favoriteButton.tintColor = .basicColor
//        }
//    }
    
    @IBAction func didFavoriteButtonTapped(_ sender: Any) {
        delegate?.didFavoriteButtonTapped(cell: self)
    }
}
