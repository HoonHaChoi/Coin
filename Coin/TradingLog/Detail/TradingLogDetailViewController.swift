//
//  TradingLogDetailViewController.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/19.
//

import UIKit

class TradingLogDetailViewController: UIViewController {
    
    private let log: TradingLog
    
    init(log: TradingLog) {
        self.log = log
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    private let statsTopStackView: StatsStackView = {
        let statsStackView = StatsStackView()
        statsStackView.setStatsTitle(leftTitle: "시작 금액", rightTitle: "수익률")
        statsStackView.translatesAutoresizingMaskIntoConstraints = false
        return statsStackView
    }()
    
    private let statsBottomStackView: StatsStackView = {
        let statsStackView = StatsStackView()
        statsStackView.setStatsTitle(leftTitle: "최종 금액", rightTitle: "수익금")
        statsStackView.translatesAutoresizingMaskIntoConstraints = false
        return statsStackView
    }()
    
    private var memoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .basicColor
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var cancellButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(onDissmiss(_:)))
        button.tintColor = .basicColor
        return button
    }()
    
    @objc func onDissmiss(_ action: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureConstraintUI()
        updateUI()
        self.navigationItem.leftBarButtonItem = cancellButton
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
    
    private func updateUI() {
        statsTopStackView.setStatsLabel(left: log.startPrice.convertPriceKRW(),
                                        right: log.rate().convertRateString())
        statsBottomStackView.setStatsLabel(left: log.endPrice.convertPriceKRW(),
                                           right: log.profit().convertPriceKRW())
        self.title = log.date.convertString()
        self.memoLabel.text = log.memo
        statsTopStackView.changeStatsLabelColor(state: log.marketColor())
        statsBottomStackView.changeStatsLabelColor(state: log.marketColor())
    }
}
