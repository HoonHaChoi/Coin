//
//  TradingLogDataSource.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/03.
//

import UIKit

class TradingLogDataSource: NSObject, UITableViewDataSource {
    
    private var tradingLogs: [TradingLogMO]
    
    override init() {
        self.tradingLogs = []
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tradingLogs.isEmpty {
            tableView.backgroundView = EmptyView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height))
        } else {
            tableView.backgroundView = nil
        }
        
        return tradingLogs.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TradingLogCell.reuseIdentifier,
                                                       for: indexPath) as? TradingLogCell else {
            return .init()
        }
        
        cell.configure(log: tradingLogs[indexPath.row])
        return cell
    }
    
    func updateLog(logs: [TradingLogMO]) {
        self.tradingLogs = logs
    }
}


