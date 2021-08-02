//
//  TradingLogDataSource.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/03.
//

import UIKit

class TradingLogDataSource: NSObject, UITableViewDataSource {
    
    private var tradingLogs: [TradingLogMO] = []
    
    init(tradingLogList: [TradingLogMO]) {
        self.tradingLogs = tradingLogList
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tradingLogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: , for: indexPath) as? TradingLogCell else {
            return .init()
        }
        return cell
    }
}


