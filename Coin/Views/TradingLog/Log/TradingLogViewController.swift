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
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    
    private let dataSource: TradingLogDataSource
    private let userSettingChange: UserSettingChangeable
    var dispatch: ((Action)->Void)?
    var statsViewUpdateHandler: (() -> Void)?
    
    init?(coder: NSCoder,
          dataSource: TradingLogDataSource,
          userSettingChange: UserSettingChangeable) {
        self.dataSource = dataSource
        self.userSettingChange = userSettingChange
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        dispatch?(.loadInitialData)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func configureTableView() {
        tradingLogTableView.register(cell: TradingLogCell.self)
        tradingLogTableView.dataSource = dataSource
        tradingLogTableView.delegate = self
        tradingLogTableView.rowHeight = UITableView.automaticDimension
        tradingLogTableView.estimatedRowHeight = 200
    }
    
    func updateState(state: ViewState) {
        dataSource.updateLog(logs: state.tradlingLogs)
        currentDateLabel.text = state.currentDateString
        nextButton.isHidden = state.nextButtonState
        previousButton.isHidden = state.previousButtonState
        tradingLogTableView.reloadData()
        statsViewUpdateHandler?()
    }
    
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        dispatch?(.didTapForWardMonth)
    }
    @IBAction func previouseButtonAction(_ sender: UIButton) {
        dispatch?(.didTapBackWardMonth)
    }
    @IBAction func ascendDateButtonAction(_ sender: UIButton) {}
    
    @IBAction func addTradingLogAction(_ sender: UIButton) {
        dispatch?(.didTapAddTradingLog)
    }
    
    @IBAction func changeOrderAction(_ sender: UIButton) {
        userSettingChange.changeAsceding()
        dispatch?(.didTapDateAscending)
    }
    
}

extension TradingLogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let row = self.dataSource.fetchTradingLog(index: indexPath.row)
        
        let deleteAction = UIContextualAction(style: .normal, title: "") { [weak self] _, _, _  in
            let alert = UIAlertController { _ in
                self?.dispatch?(.deleteTradingLog(row.date))
            }
            self?.present(alert, animated: true, completion: nil)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "") { [weak self] _, _, _ in
            self?.dispatch?(.didTapEditTradingLog(row))
        }
        
        deleteAction.backgroundColor = .systemBackground
        deleteAction.image = UIImage(systemName: "trash")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        
        editAction.backgroundColor = .systemBackground
        editAction.image = UIImage(systemName: "square.and.pencil")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = self.dataSource.fetchTradingLog(index: indexPath.row)
        let detailView = TradingLogDetailViewController(log: row)
        self.present(detailView, animated: true, completion: nil)
    }
}
