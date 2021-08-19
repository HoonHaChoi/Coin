//
//  TradingLogStatsViewController.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/13.
//

import UIKit

final class TradingLogStatsViewController: UIViewController, Storyboarded {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @IBOutlet weak var tempChartView: UIView!
    
    private let chartContainerView: ChartContainerView  = {
        let chart = ChartContainerView()
        chart.backgroundColor = .systemBackground
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
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
    
    private let currentDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .basicColor
        label.text = "0000.00"
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: .zero, weight: .regular, scale: .large), forImageIn: .normal)
        button.tintColor = .basicColor
        button.addTarget(self, action: #selector(nextDidTapAction), for: .touchUpInside)
        return button
    }()
    
    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: .zero, weight: .regular, scale: .large), forImageIn: .normal)
        button.tintColor = .basicColor
        button.addTarget(self, action: #selector(previousDidTapAction(_:)       ), for: .touchUpInside)
        return button
    }()
    
    var moveMonthAction: ((MonthMoveAction) -> ())?
    var requestStats: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        constraintUI()
    }
    
    private func constraintUI() {
        view.addSubview(chartContainerView)
        view.addSubview(currentDateLabel)
        view.addSubview(nextButton)
        view.addSubview(previousButton)
        view.addSubview(statsTopStackView)
        view.addSubview(statsBottomStackView)
        
        NSLayoutConstraint.activate([
            chartContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            chartContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            chartContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            chartContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45),
            
            currentDateLabel.topAnchor.constraint(equalTo: chartContainerView.bottomAnchor, constant: 30),
            currentDateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nextButton.leadingAnchor.constraint(equalTo: currentDateLabel.trailingAnchor, constant: 20),
            nextButton.centerYAnchor.constraint(equalTo: currentDateLabel.centerYAnchor),
            
            previousButton.trailingAnchor.constraint(equalTo: currentDateLabel.leadingAnchor, constant: -20),
            previousButton.centerYAnchor.constraint(equalTo: currentDateLabel.centerYAnchor),
            
            statsTopStackView.topAnchor.constraint(equalTo: currentDateLabel.bottomAnchor, constant: 30),
            statsTopStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statsTopStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            statsBottomStackView.topAnchor.constraint(equalTo: statsTopStackView.bottomAnchor, constant: 10),
            statsBottomStackView.leadingAnchor.constraint(equalTo: statsTopStackView.leadingAnchor),
            statsBottomStackView.trailingAnchor.constraint(equalTo: statsTopStackView.trailingAnchor)
        ])
    }
    
    @objc func nextDidTapAction(_ sender: UIButton) {
        moveMonthAction?(.next)
    }
    
    @objc func previousDidTapAction(_ sender: UIButton) {
        moveMonthAction?(.previous)
    }
    
    func updateUI(dto: TradingLogStatsDTO) {
        statsTopStackView.setStatsLabel(left: dto.stats.endPirceString(),
                                        right: dto.stats.rate())
        statsBottomStackView.setStatsLabel(left: dto.stats.logCountString(),
                                        right: dto.stats.profit())
        hideMoveButton(nextHideState: dto.nextButtonState,
                       previousHideState: dto.previousButtonState)
        currentDateLabel.text = dto.currentDateString
        statsTopStackView.changeStatsLabelColor(state: dto.stats.stateColor)
        statsBottomStackView.changeStatsLabelColor(state: dto.stats.stateColor)
        chartContainerView.updateChartUI(dto: dto)
    }
    
    private func hideMoveButton(nextHideState: Bool, previousHideState: Bool) {
        nextButton.isHidden = nextHideState
        previousButton.isHidden = previousHideState
    }
}
