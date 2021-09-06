//
//  DetailInfoView.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/07.
//

import UIKit

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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
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
            OutputPriceStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 10)
        ])
    }
}
