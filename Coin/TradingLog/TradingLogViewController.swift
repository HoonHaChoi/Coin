//
//  TradingLogViewController.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/31.
//

import UIKit

final class TradingLogViewController: UIViewController, Storyboarded {
 
    @IBOutlet weak var tradingLogTableView: UITableView!

    private let dataSource: TradingLogDataSource
    
    init?(coder: NSCoder,
          dataSource: TradingLogDataSource) {
        self.dataSource = dataSource
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tradingLogTableView.register(cell: TradingLogCell.self)
        tradingLogTableView.dataSource = dataSource
    }
}

