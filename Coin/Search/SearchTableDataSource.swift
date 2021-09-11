//
//  SearchTableDataSource.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/02.
//

import UIKit

class SearchTableDataSource: NSObject, UITableViewDataSource {
    
    private var model: [Coin]
    private var state: [Bool]
    var favoriteButtonTappedHandler: ((SearchCoinCell) -> ())?
    let configure:(SearchCoinCell,Coin,Bool) -> ()
    
    init(configure: @escaping (SearchCoinCell,Coin,Bool) -> ()) {
        self.model = []
        self.state = []
        self.configure = configure
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCoinCell.reuseIdentifier, for: indexPath) as? SearchCoinCell else {
            return .init()
        }
        cell.delegate = self
        configure(cell, model[indexPath.row], state[indexPath.row])
        return cell
    }
    
    func updateDataSource(from coinList: [Coin]) {
        self.model = coinList
        self.state = coinList.map { _ in false }
    }
    
    func updateState(from states: [Int]) {
        states.forEach { index in
            state[index] = !state[index]
        }
    }
    
    func findIndexes<T: StringProtocol>(uuids: [T]) -> [Int] {
        uuids.reduce([]) { currentResult, currentMeta in
            if let coin = self.model.firstIndex(
                where: { coin in coin.uuid == currentMeta }) {
                return currentResult + [coin]
            }
            return currentResult
        }
    }
    
    func selectModel(index: Int, handler: (String) -> Void) {
        handler(model[index].uuid)
    }
}

extension SearchTableDataSource: FavoriteButtonTappedDelegate {
    func didFavoriteButtonTapped(cell: SearchCoinCell) {
        favoriteButtonTappedHandler?(cell)
    }
}
