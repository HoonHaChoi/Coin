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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configure()
    }
    
    private func configure() {
        view.addSubview(exchangeSegment)
        NSLayoutConstraint.activate([
            exchangeSegment.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            exchangeSegment.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            exchangeSegment.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            exchangeSegment.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc private func selectExchangeItem(_ sender: UISegmentedControl) {}
    
}
