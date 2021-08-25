//
//  CryptoTableView.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/23.
//

import UIKit

final class CryptoView: UIView {
    
    let cryptoTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.tableFooterView = UIView()
        table.rowHeight = 70
        table.estimatedRowHeight = 70
        table.sectionHeaderHeight = 50
        table.estimatedSectionHeaderHeight = 50
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        addSubview(cryptoTableView)
        
        NSLayoutConstraint.activate([
            cryptoTableView.topAnchor.constraint(equalTo: topAnchor),
            cryptoTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cryptoTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cryptoTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    
}
