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
    
    private var statsStackView: StatsStackView = {
       let recordView = StatsStackView()
        recordView.translatesAutoresizingMaskIntoConstraints = false
        return recordView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        constraintUI()
    }
    
    private func constraintUI() {
        view.addSubview(statsStackView)
        
        statsStackView.topAnchor.constraint(equalTo: currentDateLabel.bottomAnchor, constant: 30).isActive = true
        statsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        statsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
    }
}
