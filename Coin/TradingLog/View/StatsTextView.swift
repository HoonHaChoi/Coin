//
//  StatsTextView.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/15.
//

import UIKit

class StatsTextView: UIView {

    private let statsTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .middleGrayColor
        label.font = .systemFont(ofSize: 15)
        label.text = "Title"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let statsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .basicColor
        label.text = "0"
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
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
        addSubview(statsTitleLabel)
        addSubview(statsLabel)
        
        NSLayoutConstraint.activate([
            statsTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            statsTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            
            statsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            statsLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func setTitleLabel(name: String) {
        statsTitleLabel.text = name
    }
    
    func setStatsLabel(stats: String) {
        statsLabel.text = stats
    }
    
}
