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
    private let cornerRadius: CGFloat = 10
    private let opacity: Float = 0.2
    private let shadowHeight: Double = 0.2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureShadow()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
        configureShadow()
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
    
    private func configureShadow() {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: .zero, height: shadowHeight)
        self.layer.shadowRadius = cornerRadius
        self.layer.shadowOpacity = opacity
    }
    
    func updateChartUI(dto: TradingLogStatsDTO) {
        chartView.setChart(labels: dto.chartStats.months, values: dto.chartStats.percentages)
    }
}
