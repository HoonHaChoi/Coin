//
//  MaketsViewController.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/22.
//

import UIKit

class ExchangeViewController: UIViewController {

    typealias cryptoDataSource = TableDataSource<CryptoCell, Coin>
    
    private let dataSource: cryptoDataSource
    private let exchangeMapper = EnumMapper(key: Array(0..<Exchange.allCases.count),
                                      item: Exchange.allCases)
    
    init(dataSource: cryptoDataSource) {
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private lazy var exchangeSegment: UISegmentedControl = {
        let segment = UISegmentedControl(items: Exchange.allCases.map { "\($0)".capitalized })
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.selectedSegmentIndex = 0
        segment.addTarget(self,
                          action: #selector(selectExchangeItem(_:)),
                          for: .valueChanged)
        return segment
    }()
    
    private var cryptoView: CryptoView = {
        let view = CryptoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var requestExchange: ((Exchange) -> ())?
    var requestSocketMeta: ((Exchange) ->())?
    var requestDisConnectSocket: (() -> ())?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configure()
        requestExchange?(.upbit)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataSource.isExistModel { [weak self] exist in
            if exist, let exchange = self?.exchangeMapper[exchangeSegment.selectedSegmentIndex] {
                self?.requestSocketMeta?(exchange)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        requestDisConnectSocket?()
    }
    
    private func configure() {
        view.addSubview(exchangeSegment)
        view.addSubview(cryptoView)
        
        NSLayoutConstraint.activate([
            exchangeSegment.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            exchangeSegment.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            exchangeSegment.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            exchangeSegment.heightAnchor.constraint(equalToConstant: 30),
            
            cryptoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cryptoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cryptoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cryptoView.topAnchor.constraint(equalTo: exchangeSegment.bottomAnchor, constant: 10)
        ])
        cryptoView.cryptoTableView.dataSource = dataSource
        cryptoView.cryptoTableView.delegate = self
    }
    
    func updateTableView(coins: [Coin]) {
        dataSource.updateDataSource(from: coins)
        DispatchQueue.main.async { [weak self] in
            self?.cryptoView.cryptoTableView.reloadData()
        }
    }
    
    func updateMeta(metaList: [CoinMeta]) {
        let findIndex = dataSource.findIndexes(metaList: metaList)
        let changes = dataSource.compareMeta(indexes: findIndex, metaList: metaList)
        dataSource.updateModel(indexes: findIndex, metaList: metaList)
        let indexPath = dataSource.makeIndexPath(indexes: findIndex)
        
        cryptoView.cryptoTableView.performBatchUpdates({
            DispatchQueue.main.async { [weak self] in
                self?.cryptoView.cryptoTableView.reloadRows(at: indexPath, with: .none)
                self?.updateChangeBackground(indexPaths: indexPath, changes: changes)
            }
        }) { _ in }
    }
    
    private func updateChangeBackground(indexPaths: [IndexPath], changes: [Change]) {
        for i in 0..<indexPaths.count {
            self.cryptoView.cryptoTableView.cellForRow(at: indexPaths[i])?
                    .updateBackgroundAnimation(change: changes[i])
        }
    }
    
    func onAlertError(message: NetworkError) {
        let alert = UIAlertController(title: "에러", message: message.description)
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
        }
    }
    
    private func changeExchange(from exchange: Exchange) {
        requestDisConnectSocket?()
        requestExchange?(exchange)
    }
    
    @objc private func selectExchangeItem(_ sender: UISegmentedControl) {
        guard let exchange = exchangeMapper[sender.selectedSegmentIndex] else {
            return
        }
        changeExchange(from: exchange)
    }
    
}

extension ExchangeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CryptoHeaderView.identifier) as? CryptoHeaderView else {
            return .init()
        }
        return headerView
    }
}
