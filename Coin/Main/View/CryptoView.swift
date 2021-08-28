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
        table.rowHeight = 60
        table.estimatedRowHeight = 60
        table.sectionHeaderHeight = 30
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
        
        cryptoTableView.register(cell: CryptoCell.self)
        cryptoTableView.register(CryptoHeaderView.nib, forHeaderFooterViewReuseIdentifier: CryptoHeaderView.identifier)
        
        NSLayoutConstraint.activate([
            cryptoTableView.topAnchor.constraint(equalTo: topAnchor),
            cryptoTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cryptoTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cryptoTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func reloadRows(at indexPath: [IndexPath],to changes: [Change]) {
        cryptoTableView.reloadRows(at: indexPath, with: .none)
        updateChangeBackground(indexPaths: indexPath, changes: changes)
    }
    
    private func updateChangeBackground(indexPaths: [IndexPath], changes: [Change]) {
        for index in 0..<indexPaths.count {
            cryptoTableView.cellForRow(at: indexPaths[index])?
                    .updateBackgroundAnimation(change: changes[index])
        }
    }
}
