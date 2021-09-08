//
//  CryptoCell.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/23.
//

import UIKit
import Combine

class CryptoCell: UITableViewCell {
    
    @IBOutlet weak var symbolImageView: UIImageView!
    @IBOutlet weak var symbolNameLabel: UILabel!
    @IBOutlet weak var symbolDescriptionLabel: UILabel!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var changeRateLabel: UILabel!
    @IBOutlet weak var changePriceLabel: UILabel!
    
    private var cancell: AnyCancellable?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(coin: Coin, imageLoader: Loader) {
        symbolNameLabel.text = coin.ticker
        currentPriceLabel.text = coin.meta.tradePrice.convertPriceKRW()
        imageLoad(loader: imageLoader, to: coin.logo)
        symbolDescriptionLabel.text = coin.exchange.rawValue + "/" + coin.market
        updateChangePriceRateLabel(to: coin)
        updateChangeColor(to: coin)
    }
    
    private func imageLoad(loader: Loader, to logoURL: String?) {
        cancell = loader.load(urlString: logoURL)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] uiImage in
                self?.symbolImageView.image = uiImage
            }
    }
    
    private func updateChangePriceRateLabel(to coin: Coin) {
        let sign = coin.meta.change.signString()
        changeRateLabel.text = sign + coin.meta.changeRate.convertPercentRate()
        changePriceLabel.text = sign + coin.meta.changePrice.convertPriceKRW()
    }
    
    private func updateChangeColor(to coin: Coin) {
        let color = coin.meta.change.matchColor()
        changeRateLabel.textColor = color
        changePriceLabel.textColor = color
    }
}
