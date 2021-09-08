//
//  NotificationHeaderView.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/08.
//

import UIKit

class NotificationHeaderView: UITableViewHeaderFooterView {

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
    
    private let symbolStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()

    private let addNotificaionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("추가", for: .normal)
        button.titleLabel?.textColor = .basicColor
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        return button
    }()
    
    private func configureUI() {
        addSubview(symbolImageView)
        addSubview(symbolStackView)
        addSubview(addNotificaionButton)
        
        symbolStackView.addArrangedSubview(symbolNameLabel)
        symbolStackView.addArrangedSubview(symbolDescriptionLabel)
        
        NSLayoutConstraint.activate([
            symbolImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            symbolImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            symbolImageView.widthAnchor.constraint(equalToConstant: 30),
            symbolImageView.heightAnchor.constraint(equalToConstant: 30),
            
            symbolStackView.topAnchor.constraint(equalTo: symbolImageView.topAnchor),
            symbolStackView.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 10),
            
            addNotificaionButton.centerXAnchor.constraint(equalTo: symbolImageView.centerXAnchor),
            addNotificaionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
}
