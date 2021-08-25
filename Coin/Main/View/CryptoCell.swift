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
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var changeRateLabel: UILabel!
    @IBOutlet weak var changePriceLabel: UILabel!
    
    private var cancell: AnyCancellable?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(coin: Coin, imageLoader: Loader,
                   colorMapper: EnumMapper<Change, UIColor>) {
        symbolNameLabel.text = coin.ticker
        currentLabel.text = coin.meta.tradePrice
        imageLoad(loader: imageLoader, to: coin.logo)
        symbolDescriptionLabel.text = coin.exchange.rawValue + "/" + coin.market
        updateChangePriceRateLabel(to: coin)
    }
    
    private func imageLoad(loader: Loader, to logoURL: String) {
        cancell = loader.load(urlString: logoURL)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] uiImage in
                self?.symbolImageView.image = uiImage
            }
    }
    
    private func updateChangePriceRateLabel(to coin: Coin) {
        
        var numberSymbol = ""
        switch coin.meta.change {
        case .even:
            changeRateLabel.textColor = .basicColor
        case .fall:
            numberSymbol = "-"
            changeRateLabel.textColor = .fallColor
        case .rise:
            numberSymbol = "+"
            changeRateLabel.textColor = .riseColor
        }
        changeRateLabel.text = numberSymbol + coin.meta.changeRate.convertPercentRate()
        changePriceLabel.text = coin.meta.changePrice.convertPriceKRW()
    }
}
