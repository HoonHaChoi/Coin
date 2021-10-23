//
//  RecordView.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/15.
//

import UIKit

class StatsStackView: UIStackView {
    
    private let statsLeftView: StatsTextView = {
        let view = StatsTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let statsRightView: StatsTextView = {
        let view = StatsTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setProperty()
        configure()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setProperty()
        configure()
    }
    
    private func configure() {
        addArrangedSubview(statsLeftView)
        addArrangedSubview(statsRightView)
        
        statsLeftView.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    private func setProperty() {
        axis = .horizontal
        alignment = .fill
        spacing = 10
        distribution = .fillEqually
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setStatsTitle(leftTitle: String, rightTitle: String) {
        statsLeftView.setTitleLabel(name: leftTitle)
        statsRightView.setTitleLabel(name: rightTitle)
    }
    
    func setStatsLabel(left: String, right: String) {
        statsLeftView.setStatsLabel(stats: left)
        statsRightView.setStatsLabel(stats: right)
    }
    
    func changeStatsLabelColor(state: Change) {
        statsRightView.changeStatsLabelColor(changeState: state)
    }
}
