//
//  TradingLogViewController.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/31.
//

import UIKit

final class TradingLogViewController: UIViewController, Storyboarded {
 
    @IBOutlet weak var tradingLogTableView: UITableView!
    @IBOutlet weak var addTradingLogButton: UIButton!
    @IBOutlet weak var orderChangeButton: UIButton!
    @IBOutlet weak var currentDateButton: UIButton!
    
    private let dataSource: TradingLogDataSource
    var dispatch: ((Action)->Void)?
    
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
        tradingLogTableView.rowHeight = UITableView.automaticDimension
        tradingLogTableView.estimatedRowHeight = 200
        dispatch?(.loadInitialData)
    }
    
    func updateState(state: ViewState) {
        dataSource.updateLog(logs: state.tradlingLogs)
    }
    
    
    @IBAction func nextButtonAction(_ sender: UIButton) {}
    @IBAction func previouseButtonAction(_ sender: UIButton) {}
    @IBAction func dateChangeButtonAction(_ sender: UIButton) {}
    @IBAction func addTradingLogAction(_ sender: UIButton) {}
    @IBAction func changeOrderAction(_ sender: UIButton) {}
    
}

