//
//  MaketsViewController.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/22.
//

import UIKit

class ExchangeViewController: UIViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configure()
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
        
        cryptoView.cryptoTableView.dataSource = self
        cryptoView.cryptoTableView.register(cell: CryptoCell.self)
    }
    
    @objc private func selectExchangeItem(_ sender: UISegmentedControl) {}
    
}

extension ExchangeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CryptoCell.reuseIdentifier, for: indexPath) as! CryptoCell
        return cell
    }
}
