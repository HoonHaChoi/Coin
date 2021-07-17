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
    @IBOutlet weak var tradePrice: UILabel!
    @IBOutlet weak var currentRate: UILabel!
    private var cancell: AnyCancellable?
    
    func configure(coin: Coin, imageLoader: Loader) {
        coinName.text = coin.koreanName
        imageLoad(loader: imageLoader, to: coin.logo)
        market.text = "\(coin.ticker)/\(coin.market)"
        tradePrice.text = coin.meta.tradePrice.convertPriceKRW()
        updateCurrentRateLabel(to: coin)
    }
    
    private func imageLoad(loader: Loader, to logoURL: String) {
        cancell = loader.load(urlString: logoURL)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] uiImage in
                self?.coinImageView.image = uiImage
            }
    }
    
    private func updateCurrentRateLabel(to coin: Coin) {
        var numberSymbol = ""
        switch coin.meta.change {
        case .even:
            currentRate.textColor = .black
        case .fall:
            numberSymbol = "+ "
            currentRate.textColor = .systemRed
        case .rise:
            numberSymbol = "- "
            currentRate.textColor = .systemBlue
        }
        currentRate.text = numberSymbol + coin.meta.changeRate.convertPercentRate()
    }
}
