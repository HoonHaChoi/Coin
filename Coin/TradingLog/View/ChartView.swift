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
    
    private func configure() {
        self.noDataText = "데이터가 없습니다..!"
        self.noDataFont = .boldSystemFont(ofSize: 20)
        self.noDataTextColor = .middleGrayColor
        
        // 드래그 금지
        self.dragEnabled = false
        
        // 더블 탭 금지
        self.doubleTapToZoomEnabled = false
        
        // 하이라이트 탭 금지
        self.highlightPerTapEnabled = false
        
        // 오른쪽 레이블,라인 제거
        self.rightAxis.drawAxisLineEnabled = false
        self.rightAxis.drawGridLinesEnabled = false
        self.rightAxis.drawLabelsEnabled = false
        
        // x 라인 제거
        self.xAxis.drawGridLinesEnabled = false
        self.xAxis.drawAxisLineEnabled = false
            
        // X축 레이블 위치조정
        self.xAxis.labelPosition = .bottom
        
        // 왼쪽 레이블,라벨 제거
        self.leftAxis.drawAxisLineEnabled = false
        self.leftAxis.drawLabelsEnabled = false
        self.leftAxis.drawGridLinesEnabled = false
        
        self.legend.enabled = false
        self.xAxis.labelFont = .systemFont(ofSize: 14, weight: .medium)
        self.xAxis.yOffset = 20
        
        self.extraTopOffset = 20
        self.extraBottomOffset = 20
    }
    
    func setChart(labels: [String], values: [Double]) {
        
        self.xAxis.valueFormatter = IndexAxisValueFormatter(values: labels)
        
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<labels.count {
            dataEntries.append(BarChartDataEntry(x: Double(i), y: values[i]))
        }
        
        let colors = dataEntries.map { (entry) -> UIColor in
            return entry.y > 0 ? .riseColor : .fallColor
        }
        
        let chartSet = BarChartDataSet(entries: dataEntries, label: "")
        chartSet.drawValuesEnabled = true
        chartSet.drawIconsEnabled = false
        chartSet.colors = colors
        chartSet.valueFont = NSUIFont.boldSystemFont(ofSize: 14)
        
        let chartData = BarChartData(dataSet: chartSet)

        // 바 넓이 수정
        // chartData.barWidth = Double(0.5)
        
        self.data = chartData
    }
}
