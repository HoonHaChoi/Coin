//
//  ExchangeDataSource.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/23.
//

import UIKit

final class TableDataSource<CellType: UITableViewCell, Model>: NSObject, UITableViewDataSource {
    
    private var coins: [Model]
    let configure:(CellType,Model) -> ()
    
    init(configure: @escaping (CellType,Model) -> ()) {
        self.coins = []
        self.configure = configure
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellType.reuseIdentifier, for: indexPath) as? CellType else {
            return .init()
        }
        configure(cell, coins[indexPath.row])
        return cell
    }
    
    func updateDataSource(from coinList: [Model]) {
        self.coins = coinList
    }
}
