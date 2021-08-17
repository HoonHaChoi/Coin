//
//  ChartHelper.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/17.
//

import Foundation

protocol ChartDTOFactory {
    func makeChartDTO(date: Date) -> TradingLogStatsChartDTO
}

struct ChartHelper: ChartDTOFactory {
    
    let manager: CoreDataFetching
    
    func makeChartDTO(date: Date) -> TradingLogStatsChartDTO {
        
        let calendar = Calendar.current
        
        var months: [String] = []
        var percentages: [Double] = []
        
        for i in 0..<6 {
            guard let date = calendar.date(byAdding: .month, value: -i, to: date),
                  let month = calendar.dateInterval(of: .month, for: date)
                  else {
                return .empty
            }
            
            percentages.append(calculatePercentResult(from: month.start, to: month.end))
            months.append(dateToMonthString(from: date))
        }
        return TradingLogStatsChartDTO(months: months,
                                       percentages: percentages)
    }
    
    private func dateToMonthString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M"
        return dateFormatter.string(from: date)+"월"
    }
    
    private func calculatePercentResult(from start: Date,to end: Date) -> Double {
        let logs = manager.fetchAscent(dates: (start: start, end: end))
        
        guard let first = logs.first, let last = logs.last else {
            return .zero
        }
        return calculatePercent(from: Int(first.startPrice), to: Int(last.endPrice))
    }
    
    private func calculatePercent(from startPrice: Int, to endPrice: Int) -> Double {
        let percent = Double(endPrice - startPrice) / Double(startPrice) * 100
        
        if percent.isFinite {
            return percent
        }
        return .zero
    }
        
}
