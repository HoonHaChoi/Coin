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
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .basicColor
        label.textAlignment = .left
        return label
    }()
    
    private let notificationRepectLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
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
    
    private lazy var notificationSwitch: UISwitch = {
        let notiSwitch = UISwitch()
        notiSwitch.translatesAutoresizingMaskIntoConstraints = false
        notiSwitch.addTarget(self, action: #selector(switchAction(_:)), for: .valueChanged)
        return notiSwitch
    }()
    
    private func configureUI() {
        addSubview(notificationStackView)
        contentView.addSubview(notificationSwitch)
        
        notificationStackView.addArrangedSubview(notificationPriceLabel)
        notificationStackView.addArrangedSubview(notificationRepectLabel)
        
        NSLayoutConstraint.activate([
            notificationStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            notificationStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            notificationSwitch.leadingAnchor.constraint(equalTo: notificationStackView.trailingAnchor, constant: 10),
            notificationSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            notificationSwitch.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    var switchActionHandler: ((NotificationCell, Bool) -> ())?
    
    func configure(from item: Notifications) {
        notificationPriceLabel.text = item.basePrice.convertPriceKRW() + "원 " + configureTypeString(itemType: item.type) + " 도달 시"
        notificationRepectLabel.text = item.notificationCycle.displayCycle + " 간격으로 알림"
        updatePriceLabelColor(itemType: item.type)
        notificationSwitch.setOn(item.isActived, animated: true)
    }
    
    private func updatePriceLabelColor(itemType: String) {
        notificationPriceLabel.textColor = itemType == "up" ? .riseColor : .fallColor
    }
    
    private func configureTypeString(itemType: String) -> String {
        itemType == "up" ? "이상" : "이하"
    }
    
    @objc private func switchAction(_ sender: UISwitch) {
        switchActionHandler?(self, sender.isOn)
    }
    
    func restoreSwitch() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.notificationSwitch.setOn(!self.notificationSwitch.isOn, animated: true)
        }
    }
}
