//
//  ChartContainerView.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/19.
//

import UIKit

class ChartContainerView: UIView {

    private let chartView: ChartView = {
        let chart = ChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }

    private func configureUI() {
        addSubview(chartView)
        
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: topAnchor),
            chartView.leadingAnchor.constraint(equalTo: leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: trailingAnchor),
            chartView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func updateChartUI(dto: TradingLogStatsDTO) {
        chartView.setChart(labels: dto.chartStats.months, values: dto.chartStats.percentages)
    }
}
