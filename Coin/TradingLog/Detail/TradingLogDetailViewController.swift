//
//  TradingLogDetailViewController.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/19.
//

import UIKit

class TradingLogDetailViewController: UIViewController {

    private let statsTopStackView: StatsStackView = {
       let statsStackView = StatsStackView()
        statsStackView.setStatsTitle(leftTitle: "최종 금액", rightTitle: "수익률")
        statsStackView.translatesAutoresizingMaskIntoConstraints = false
        return statsStackView
    }()
    
    private let statsBottomStackView: StatsStackView = {
       let statsStackView = StatsStackView()
        statsStackView.setStatsTitle(leftTitle: "기록 일수", rightTitle: "수익금")
        statsStackView.translatesAutoresizingMaskIntoConstraints = false
        return statsStackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configure()
    }

    func configure() {
        view.addSubview(statsTopStackView)
        view.addSubview(statsBottomStackView)
        
        NSLayoutConstraint.activate([
            statsTopStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            statsTopStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statsTopStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            statsBottomStackView.topAnchor.constraint(equalTo: statsTopStackView.bottomAnchor, constant: 10),
            statsBottomStackView.leadingAnchor.constraint(equalTo: statsTopStackView.leadingAnchor),
            statsBottomStackView.trailingAnchor.constraint(equalTo: statsTopStackView.trailingAnchor)
        ])
    }
}
