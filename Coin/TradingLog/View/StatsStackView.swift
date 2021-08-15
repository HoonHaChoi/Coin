//
//  RecordView.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/15.
//

import UIKit

class StatsStackView: UIStackView {
    
    private let statsFinalAmountView: StatsTextView = {
        let view = StatsTextView()
        view.setTitleLabel(name: "최종 금액")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let statsRateView: StatsTextView = {
        let view = StatsTextView()
        view.setTitleLabel(name: "수익률")
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
        addArrangedSubview(statsFinalAmountView)
        addArrangedSubview(statsRateView)
        
        statsFinalAmountView.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    private func setProperty() {
        axis = .horizontal
        alignment = .fill
        spacing = 10
        distribution = .fillEqually
        translatesAutoresizingMaskIntoConstraints = false
    }
}
