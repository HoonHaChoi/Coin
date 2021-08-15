//
//  CoreDataStorage.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/30.
//

import UIKit
import CoreData

protocol CoreDataStorage {
    func fetch(dates: (start: Date,end: Date)) -> [TradingLogMO]
    func insert(tradingLog: TradingLog) -> Bool
    func update(tradingLog: TradingLog) -> Bool
    func delete(date: Date) -> Bool
    func find(date: Date) -> [TradingLogMO]
}

struct CoreDataStorageManager: CoreDataStorage {
    
    private let container: NSPersistentContainer
    private let fetchRequest: NSFetchRequest<TradingLogMO>
    private let context: NSManagedObjectContext
    private let modelName: String
    private let userSetting: UserSettingFetching
    
    init(modelName: String, userSetting: UserSettingFetching) {
        self.modelName = modelName
        self.userSetting = userSetting
        self.container = NSPersistentContainer(name: modelName)
        self.fetchRequest = TradingLogMO.fetchRequest()
        container.loadPersistentStores { store, error in
            if error != nil {
                fatalError()
            }
        }
        self.context = container.viewContext
    }
    
    func fetch(dates: (start: Date,end: Date)) -> [TradingLogMO] {
        
        fetchRequest.predicate = NSPredicate(format: "date >= %@ && date <= %@",
                                             dates.start as NSDate,
                                             dates.end as NSDate)
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date",
                                                         ascending: userSetting.fetchAscendingBool())]
        
        guard let tradMO = try? context.fetch(fetchRequest) else {
            return []
        }
        return tradMO
    }
    
    @discardableResult
    func insert(tradingLog: TradingLog) -> Bool {

        guard let object = NSEntityDescription.insertNewObject(forEntityName: "TradingLog", into: context) as? TradingLogMO else {
            return false
        }
        
        object.startPrice = Int64(tradingLog.startPrice)
        object.endPrice = Int64(tradingLog.endPrice)
        object.date = tradingLog.date.removeTimeStamp()
        object.rate = tradingLog.rate()
        object.profit = Int64(tradingLog.profit())
        object.marketState = tradingLog.market.state
        object.memo = tradingLog.memo
        return save()
    }
    
    func update(tradingLog: TradingLog) -> Bool {
        
        fetchRequest.predicate = NSPredicate(format: "date == %@",
                                             tradingLog.date as NSDate)
        guard let tradingLogs = try? context.fetch(fetchRequest),
              let log = tradingLogs.first else {
            return false
        }
        log.startPrice = Int64(tradingLog.startPrice)
        log.endPrice = Int64(tradingLog.endPrice)
        log.rate = tradingLog.rate()
        log.profit = Int64(tradingLog.profit())
        log.marketState = tradingLog.market.state
        log.memo = tradingLog.memo ?? ""
        return save()
    }
    
    func delete(date: Date) -> Bool {
        
        fetchRequest.predicate = NSPredicate(format: "date == %@",
                                             date as NSDate)
        
        guard let tradMO = try? context.fetch(fetchRequest),
              let tradMOfirst = tradMO.first else {
            return false
        }

        let object = context.object(with: tradMOfirst.objectID)
        context.delete(object)
        
        return save()
    }
    
    func find(date: Date) -> [TradingLogMO] {
        fetchRequest.predicate = NSPredicate(format: "date == %@",
                                             date as NSDate)
        guard let tradMO = try? context.fetch(fetchRequest) else {
            return []
        }
        return tradMO
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
