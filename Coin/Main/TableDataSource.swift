//
//  ExchangeDataSource.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/23.
//

import UIKit

class TableDataSource<CellType: UITableViewCell, Model>: NSObject, UITableViewDataSource {
    
    private(set) var model: [Model]
    private let emptyView: UIView
    let configure:(CellType,Model) -> ()
    
    init(emptyView: UIView, configure: @escaping (CellType,Model) -> ()) {
        self.model = []
        self.emptyView = emptyView
        self.configure = configure
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if model.isEmpty {
            tableView.backgroundView = emptyView
        } else {
            tableView.backgroundView = nil
        }
        
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
    func findIndexes<T: StringProtocol>(uuids: [T]) -> [Int] {
        uuids.reduce([]) { currentResult, currentMeta in
            if let coin = self.model.firstIndex(
                where: { coin in coin.uuid == currentMeta }) {
                return currentResult + [coin]
            }
            return currentResult
        }
    }
    
    func compareMeta(indexes: [Int], metaList: [CoinMeta]) -> [Change] {
        var changes: [Change] = []
        for i in 0..<indexes.count {
            let currentModel = Double(self.model[indexes[i]].meta.tradePrice) ?? 0.0
            let changeModel = Double(metaList[i].meta.tradePrice) ?? 0.0
            
            if currentModel > changeModel {
                changes.append(.fall)
            } else if currentModel < changeModel {
                changes.append(.rise)
            } else {
                changes.append(.even)
            }
        }
        return changes
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
    
    func selectModel(index: Int, handler: (String) -> Void) {
        handler(model[index].uuid)
    }
}
