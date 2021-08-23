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
    
    func configure(coin: Coin, imageLoader: Loader) {
        currentLabel.text = coin.koreanName
        imageLoad(loader: imageLoader, to: coin.logo)
        symbolDescriptionLabel.text = "\(coin.ticker)/\(coin.market)"
        changePriceLabel.text = coin.meta.tradePrice.convertPriceKRW()
        updateCurrentRateLabel(to: coin)
    }
    
    private func imageLoad(loader: Loader, to logoURL: String) {
        cancell = loader.load(urlString: logoURL)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] uiImage in
                self?.symbolImageView.image = uiImage
            }
    }
    
    private func updateCurrentRateLabel(to coin: Coin) {
        var numberSymbol = ""
        switch coin.meta.change {
        case .even:
            changeRateLabel.textColor = .black
        case .fall:
            numberSymbol = "- "
            changeRateLabel.textColor = .systemBlue
        case .rise:
            numberSymbol = "+ "
            changeRateLabel.textColor = .systemRed
        }
        changeRateLabel.text = numberSymbol + coin.meta.changeRate.convertPercentRate()
    }
}
