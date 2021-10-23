//
//  DetailInfoView.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/07.
//

import UIKit
import Combine

class DetailInfoView: UIView {

    private let symbolImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let symbolNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .basicColor
        return label
    }()
    
    private let symbolDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .middleGrayColor
        return label
    }()
    
    private let currentPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .basicColor
        label.textAlignment = .right
        return label
    }()
    
    private let changeRateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private let changePriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private let symbolStackView: UIStackView = {
       let stack = UIStackView()
        stack.alignment = .fill
        stack.distribution = .fill
        stack.axis = .vertical
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
       return stack
    }()
 
    private let OutputPriceStackView: UIStackView = {
       let stack = UIStackView()
        stack.alignment = .fill
        stack.distribution = .fill
        stack.axis = .vertical
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
       return stack
    }()
    
    private let OutputChangeStackView: UIStackView = {
       let stack = UIStackView()
        stack.alignment = .fill
        stack.distribution = .fill
        stack.axis = .horizontal
        stack.spacing = 10
       return stack
    }()
    
    private var cancell: AnyCancellable?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        constrainUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        constrainUI()
    }

    private func constrainUI() {
        addSubview(symbolImageView)
        addSubview(symbolStackView)
        addSubview(OutputPriceStackView)
        
        symbolStackView.addArrangedSubview(symbolNameLabel)
        symbolStackView.addArrangedSubview(symbolDescriptionLabel)
        
        OutputPriceStackView.addArrangedSubview(currentPriceLabel)
        OutputPriceStackView.addArrangedSubview(OutputChangeStackView)
        OutputChangeStackView.addArrangedSubview(changePriceLabel)
        OutputChangeStackView.addArrangedSubview(changeRateLabel)
        
        NSLayoutConstraint.activate([
            symbolImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            symbolImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            symbolImageView.widthAnchor.constraint(equalToConstant: 30),
            symbolImageView.heightAnchor.constraint(equalToConstant: 30),
            
            symbolStackView.topAnchor.constraint(equalTo: symbolImageView.topAnchor),
            symbolStackView.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 10),
            
            OutputPriceStackView.topAnchor.constraint(equalTo: symbolStackView.topAnchor),
            OutputPriceStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
    
    func configure(coin: Coin, imageLoader: Loader) {
        symbolNameLabel.text = coin.ticker
        symbolDescriptionLabel.text = coin.exchange.rawValue + "/" + coin.market
        currentPriceLabel.text = coin.meta.tradePrice.convertPriceKRW()
        updateChangePriceRateLabel(to: coin.meta)
        updateChangeColor(to: coin.meta)
        imageLoad(loader: imageLoader, to: coin.logo)
    }
    
    private func imageLoad(loader: Loader, to logoURL: String?) {
        cancell = loader.load(urlString: logoURL)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] uiImage in
                self?.symbolImageView.image = uiImage
            }
    }
    
    private func updateChangePriceRateLabel(to meta: Meta) {
        let sign = meta.change.signString()
        changeRateLabel.text = sign + meta.changeRate.convertPercentRate()
        changePriceLabel.text = sign + meta.changePrice.convertPriceKRW()
    }
    
    private func updateChangeColor(to meta: Meta) {
        let color = setChangeColor(change: meta.change)
        changeRateLabel.textColor = color
        changePriceLabel.textColor = color
    }
    
    func updateUI(coin: CoinMeta) {
        DispatchQueue.main.async { [weak self] in
            self?.currentPriceLabel.text = coin.meta.tradePrice.convertPriceKRW()
            self?.updateChangePriceRateLabel(to: coin.meta)
            self?.updateChangeColor(to: coin.meta)
        }
    }
}
