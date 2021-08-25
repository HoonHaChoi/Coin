//
//  ExchangeDataSource.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/23.
//

import UIKit

class TableDataSource<CellType: UITableViewCell, Model>: NSObject, UITableViewDataSource {
    
    private var model: [Model]
    let configure:(CellType,Model) -> ()
    
    init(configure: @escaping (CellType,Model) -> ()) {
        self.model = []
        self.configure = configure
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellType.reuseIdentifier, for: indexPath) as? CellType else {
            return .init()
        }
        configure(cell, model[indexPath.row])
        return cell
    }
    
    func updateDataSource(from coinList: [Model]) {
        self.model = coinList
    }
    
    func isExistModel(handler: (Bool) -> ()) {
        handler(!model.isEmpty)
    }
}

extension TableDataSource where Model == Coin {
    func findIndexes(metaList: [CoinMeta]) -> [Int] {
        metaList.reduce([]) { currentResult, currentMeta in
            if let coin = self.model.firstIndex(
                where: { coin in coin.uuid == currentMeta.uuid}) {
                return currentResult + [coin]
            }
            return currentResult
        }
    }
    
    func updateModel(indexes: [Int], metaList: [CoinMeta]) {
        for i in 0..<indexes.count {
            self.model[indexes[i]].meta = metaList[i].meta
        }
    }
    
    func makeIndexPath(indexes: [Int]) -> [IndexPath] {
        indexes.reduce([]) { currentResult,
                             currentIndex -> [IndexPath] in
            if currentIndex < model.count {
                return currentResult + [IndexPath(row: currentIndex,
                                                  section: 0)]
            }
            return currentResult
        }
    }
}
