//
//  BarChartView.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/17.
//

import UIKit
import Charts

class ChartView: BarChartView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    func configure() {
        self.noDataText = "데이터가 없습니다..!"
        self.noDataFont = .boldSystemFont(ofSize: 20)
        self.noDataTextColor = .middleGrayColor
    }
}
