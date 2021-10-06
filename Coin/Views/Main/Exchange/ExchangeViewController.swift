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
    private let sortHelper: CoinSortHelper
    
    init(dataSource: cryptoDataSource,
         coinSortHelper: CoinSortHelper) {
        self.dataSource = dataSource
        self.sortHelper = coinSortHelper
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
    
    var requestExchange: ((Exchange)->Void)?
    var requestSocketMeta: ((Exchange)->Void)?
    var requestExchangeSocket: ((Exchange)->Void)?
    var requestLeaveEvent: ((String)->Void)?
    var requestLeaveCurrentEvent: ((()->Void)->Void)?
    var didCellTapped: ((Coin)->Void)?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configure()
        requestExchange?(.upbit)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let exchange = exchangeMapper[exchangeSegment.selectedSegmentIndex] {
            requestSocketMeta?(exchange)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        requestLeaveEvent?(currentExchangeString())
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
        let findIndex = dataSource.findIndexes(uuids: metaList.map { $0.uuid })
        let changes = dataSource.compareMeta(indexes: findIndex, metaList: metaList)
        dataSource.updateModel(indexes: findIndex, metaList: metaList)
        let indexPath = dataSource.makeIndexPath(indexes: findIndex)
        
        DispatchQueue.main.async { [weak self] in
            self?.cryptoView.reloadRows(at: indexPath, to: changes)
        }
    }
    
    func onAlertError(message: NetworkError) {
        let alert = UIAlertController(title: "에러", message: message.description)
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
        }
    }
    
    @objc private func selectExchangeItem(_ sender: UISegmentedControl) {
        guard let exchange = exchangeMapper[sender.selectedSegmentIndex] else {
            return
        }
        requestLeaveCurrentEvent? {
            requestExchangeSocket?(exchange)
        }
        reloadHeaderView()
    }
    
    private func currentExchangeString() -> String {
        guard let exchange = exchangeMapper[exchangeSegment.selectedSegmentIndex] else {
            return ""
        }
        return exchange.toString
    }
    
    private func reloadHeaderView() {
        DispatchQueue.main.async { [weak self] in
            self?.cryptoView.reloadSection()
        }
    }
}

extension ExchangeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CryptoHeaderView.identifier) as? CryptoHeaderView else {
            return .init()
        }
        headerView.delegate = self
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didCellTapped?(dataSource.model[indexPath.row])
    }
}

extension ExchangeViewController: CryptoHeaderViewDelegate {
    func didTickerSortAction(action: PlusMinusAction) {
        sortHelper.sortTicker(coins: dataSource.model, action: action)
        { [weak self] sortCoin in
            dataSource.updateDataSource(from: sortCoin)
            DispatchQueue.main.async {
                self?.cryptoView.cryptoTableView.reloadData()
            }
        }
    }
    
    func didCurrentPriceSortAction(action: PlusMinusAction) {
        sortHelper.sortTradePrice(coins: dataSource.model, action: action)
        { [weak self] sortCoin in
            dataSource.updateDataSource(from: sortCoin)
            DispatchQueue.main.async {
                self?.cryptoView.cryptoTableView.reloadData()
            }
        }
    }
    
    func didChangeSortAction(action: PlusMinusAction) {
        sortHelper.sortChangeRate(coins: dataSource.model, action: action)
        { [weak self] sortCoin in
            dataSource.updateDataSource(from: sortCoin)
            DispatchQueue.main.async {
                self?.cryptoView.cryptoTableView.reloadData()
            }
        }
    }
    
}
