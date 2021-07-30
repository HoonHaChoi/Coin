//
//  CoreDataStorage.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/30.
//

import UIKit
import CoreData

protocol CoreDataStorage {
    func fetch() -> [TradingLogMO]
    func insert(start: Int, end: Int, date: Date) -> Bool
    func update(index: Int, start: Int, end: Int) -> Bool
    func delete(index: Int) -> Bool
}

struct CoreDataStorageManager: CoreDataStorage {
    
    private let container: NSPersistentContainer
    private let fetchRequest: NSFetchRequest<TradingLogMO>
    private let context: NSManagedObjectContext
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
        self.container = NSPersistentContainer(name: modelName)
        self.fetchRequest = TradingLogMO.fetchRequest()
        container.loadPersistentStores { store, error in
            if error != nil {
                fatalError()
            }
        }
        self.context = container.viewContext
    }
    
    func fetch() -> [TradingLogMO] {
        guard let tradMO = try? context.fetch(fetchRequest) else {
            return []
        }
        return tradMO
    }
    
    func insert(start: Int, end: Int, date: Date) -> Bool {
        var trading = TradingLog(startPrice: start, endPrice: end, date: date)
        
        guard let object = NSEntityDescription.insertNewObject(forEntityName: modelName, into: context) as? TradingLogMO else {
            return false
        }
        
        object.startPrice = Int64(trading.startPrice)
        object.endPrice = Int64(trading.endPrice)
        object.date = trading.date
        object.rate = trading.rate
        object.profit = Int64(trading.profit)
        object.marketState = trading.market.state
        
        return save()
    }
    
    func update(index: Int, start: Int, end: Int) -> Bool {
        guard let tradMO = try? context.fetch(fetchRequest) else {
            return false
        }
        var dummyTrading = TradingLog(startPrice: start, endPrice: end, date: Date())
        
        tradMO[index].startPrice = Int64(dummyTrading.startPrice)
        tradMO[index].endPrice = Int64(dummyTrading.endPrice)
        tradMO[index].rate = dummyTrading.rate
        tradMO[index].profit = Int64(dummyTrading.profit)
        tradMO[index].marketState = dummyTrading.market.state
        
        return save()
    }
    
    func delete(index: Int) -> Bool {
        guard let tradMO = try? context.fetch(fetchRequest) else {
            return false
        }

        let object = context.object(with: tradMO[index].objectID)
        context.delete(object)
        
        return save()
    }
    
    private func save() -> Bool {
        do {
            try context.save()
            return true
        } catch {
            context.rollback()
            return false
        }
    }
}
