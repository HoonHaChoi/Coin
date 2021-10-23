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
        label.font = .systemFont(ofSize: 18, weight: .semibold)
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
        layer.cornerRadius = 10
        backgroundColor = .statsBackground
        
        addSubview(statsTitleLabel)
        addSubview(statsLabel)
        
        NSLayoutConstraint.activate([
            statsTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            statsTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            
            statsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            statsLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func setTitleLabel(name: String) {
        statsTitleLabel.text = name
    }
    
    func setStatsLabel(stats: String) {
        statsLabel.text = stats
    }
    
    func changeStatsLabelColor(changeState: Change) {
        var color: UIColor?
        switch changeState {
        case .rise:
            color = .riseColor
        case .fall:
            color = .fallColor
        case .even:
            color = .basicColor
        }
        statsLabel.textColor = color
    }
}
