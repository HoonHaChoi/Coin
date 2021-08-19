//
//  TradingLogDetailViewController.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/19.
//

import UIKit

class TradingLogDetailViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
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
    
    private let memoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .basicColor
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureConstraintUI()
    }
    
    private func configureConstraintUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(statsTopStackView)
        scrollView.addSubview(statsBottomStackView)
        scrollView.addSubview(memoLabel)
            
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            statsTopStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            statsTopStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            statsTopStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            statsTopStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            statsBottomStackView.topAnchor.constraint(equalTo: statsTopStackView.bottomAnchor, constant: 10),
            statsBottomStackView.leadingAnchor.constraint(equalTo: statsTopStackView.leadingAnchor),
            statsBottomStackView.trailingAnchor.constraint(equalTo: statsTopStackView.trailingAnchor),
            
            memoLabel.topAnchor.constraint(equalTo: statsBottomStackView.bottomAnchor, constant: 20),
            memoLabel.leadingAnchor.constraint(equalTo: statsTopStackView.leadingAnchor),
            memoLabel.trailingAnchor.constraint(equalTo: statsTopStackView.trailingAnchor),
            memoLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20)
        ])
    }
}
