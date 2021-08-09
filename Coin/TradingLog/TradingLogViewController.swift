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
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    
    private let dataSource: TradingLogDataSource
    var dispatch: ((Action)->Void)?
    var coordinator: TradingLogCoordinator?
    
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
        tradingLogTableView.delegate = self
        tradingLogTableView.rowHeight = UITableView.automaticDimension
        tradingLogTableView.estimatedRowHeight = 200
        dispatch?(.loadInitialData)
    }
    
    func updateState(state: ViewState) {
        dataSource.updateLog(logs: state.tradlingLogs)
        currentDateButton.setTitle(state.currentDateString, for: .normal)
        nextButton.isHidden = state.nextButtonState
        previousButton.isHidden = state.previousButtonState
        
        tradingLogTableView.reloadData()
    }
    
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        dispatch?(.didTapForWardMonth)
    }
    @IBAction func previouseButtonAction(_ sender: UIButton) {
        dispatch?(.didTapBackWardMonth)
    }
    @IBAction func dateChangeButtonAction(_ sender: UIButton) {}
    
    @IBAction func addTradingLogAction(_ sender: UIButton) {
        dispatch?(.didTapAddTradingLog)
//        coordinator?.addTradingLogTapped()
    }
    
    @IBAction func changeOrderAction(_ sender: UIButton) {}
    
}

extension TradingLogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "") { [weak self] _, _, _  in
            guard let row = self?.dataSource.fetchTradingLog(index: indexPath.row),
                  let tradinglogDate = row.date else {
                return
            }
            let alert = UIAlertController { _ in
                self?.dispatch?(.deleteTradingLog(tradinglogDate))
            }
            self?.present(alert, animated: true, completion: nil)
        }
        
        deleteAction.backgroundColor = .systemBackground
        deleteAction.image = UIImage(systemName: "trash")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
