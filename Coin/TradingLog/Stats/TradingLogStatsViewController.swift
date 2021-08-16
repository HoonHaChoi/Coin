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
    
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    private var statsTopStackView: StatsStackView = {
       let statsStackView = StatsStackView()
        statsStackView.setStatsTitle(leftTitle: "최종 금액", rightTitle: "수익률")
        statsStackView.translatesAutoresizingMaskIntoConstraints = false
        return statsStackView
    }()
    
    private var statsBottomStackView: StatsStackView = {
       let statsStackView = StatsStackView()
        statsStackView.setStatsTitle(leftTitle: "기록 일수", rightTitle: "수익금")
        statsStackView.translatesAutoresizingMaskIntoConstraints = false
        return statsStackView
    }()
    
    var moveMonthAction: ((MonthMoveAction) -> ())?
    var requestStats: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        constraintUI()
        requestStats?()
    }
    
    private func constraintUI() {
        view.addSubview(statsTopStackView)
        view.addSubview(statsBottomStackView)
        
        NSLayoutConstraint.activate([
            statsTopStackView.topAnchor.constraint(equalTo: currentDateLabel.bottomAnchor, constant: 30),
            statsTopStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statsTopStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            statsBottomStackView.topAnchor.constraint(equalTo: statsTopStackView.bottomAnchor, constant: 10),
            statsBottomStackView.leadingAnchor.constraint(equalTo: statsTopStackView.leadingAnchor),
            statsBottomStackView.trailingAnchor.constraint(equalTo: statsTopStackView.trailingAnchor)
        ])
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        moveMonthAction?(.next)
    }
    
    @IBAction func previousButtonAction(_ sender: UIButton) {
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
    }
    
    private func hideMoveButton(nextHideState: Bool, previousHideState: Bool) {
        nextButton.isHidden = nextHideState
        previousButton.isHidden = previousHideState
    }
}
