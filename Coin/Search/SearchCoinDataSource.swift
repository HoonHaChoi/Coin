//
//  SearchCoinDataSource.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/12.
//

import UIKit

class SearchCoinDataSource: NSObject, UITableViewDataSource {
    
    private var coins: [Coin]
    private let imageLoader: Loader
    
    init(imageLoader: Loader) {
        self.coins = []
        self.imageLoader = imageLoader
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCoinCell.reuseIdentifier, for: indexPath) as? SearchCoinCell else {
            return .init()
        }
        cell.configure(coin: coins[indexPath.row],
                       imageLoader: imageLoader)
        return cell
    }
    
    func updateDataSource(from coinList: [Coin]) {
        self.coins = coinList
    }
}

