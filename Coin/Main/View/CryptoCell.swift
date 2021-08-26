//
//  CryptoCell.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/23.
//

import UIKit
import Combine

class CryptoCell: UITableViewCell {

    typealias colorMap = EnumMapper<Change, UIColor>
    typealias signMap = EnumMapper<Change, String>
    
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
                   colorMapper: colorMap,
                   signMapper: signMap) {
        symbolNameLabel.text = coin.ticker
        currentLabel.text = coin.meta.tradePrice
        imageLoad(loader: imageLoader, to: coin.logo)
        symbolDescriptionLabel.text = coin.exchange.rawValue + "/" + coin.market
        updateChangePriceRateLabel(to: coin, mapper: signMapper)
        updateChangeColor(to: coin, mapper: colorMapper)
    }
    
    private func imageLoad(loader: Loader, to logoURL: String?) {
        cancell = loader.load(urlString: logoURL)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] uiImage in
                self?.symbolImageView.image = uiImage
            }
    }
    
    private func updateChangePriceRateLabel(to coin: Coin,
                                            mapper: signMap) {
        guard let sign = mapper[coin.meta.change] else {
             return
        }
        changeRateLabel.text = sign + coin.meta.changeRate.convertPercentRate()
        changePriceLabel.text = sign + coin.meta.changePrice.convertPriceKRW()
    }
    
    private func updateChangeColor(to coin: Coin,
                                   mapper: colorMap) {
        guard let color = mapper[coin.meta.change] else {
             return
        }
        changeRateLabel.textColor = color
        changePriceLabel.textColor = color
    }
}
