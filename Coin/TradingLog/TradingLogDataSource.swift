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
}


