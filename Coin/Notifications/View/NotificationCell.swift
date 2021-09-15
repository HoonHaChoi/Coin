//
//  NotificationCell.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/08.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }

    private let notificationPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .basicColor
        label.textAlignment = .left
        return label
    }()
    
    private let notificationRepectLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .basicColor
        label.textAlignment = .left
        return label
    }()
    
    private let notificationStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    private let notificationSwitch: UISwitch = {
        let notiSwitch = UISwitch()
        notiSwitch.translatesAutoresizingMaskIntoConstraints = false
        return notiSwitch
    }()
    
    private func configureUI() {
        addSubview(notificationStackView)
        addSubview(notificationSwitch)
        
        notificationStackView.addArrangedSubview(notificationPriceLabel)
        notificationStackView.addArrangedSubview(notificationRepectLabel)
        
        NSLayoutConstraint.activate([
            notificationStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            notificationStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            notificationSwitch.leadingAnchor.constraint(equalTo: notificationStackView.trailingAnchor, constant: 20),
            notificationSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            notificationSwitch.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func configure(from item: Notifications) {
        notificationPriceLabel.text = item.basePrice
        notificationRepectLabel.text = item.notificationCycle.displayCycle
    }
}
