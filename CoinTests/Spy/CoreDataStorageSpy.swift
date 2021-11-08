//
//  CoreDateStorageSpy.swift
//  CoinTests
//
//  Created by HOONHA CHOI on 2021/11/07.
//

import Foundation
import CoreData

class CoreDataStorageSpy: BaseSpy, CoreDataStorage {
    
    var dummyData: [TradingLog]
    private let container: NSPersistentContainer
    private let fetchRequest: NSFetchRequest<TradingLogMO>
    private var context: NSManagedObjectContext
    
    init(isSuccess: Bool, mockContainer: NSPersistentContainer) {
        dummyData = []
        fetchRequest = TradingLogMO.fetchRequest()
        container = mockContainer
        context = container.viewContext
        super.init(isSuccess: isSuccess)
        dummyInsert()
    }
    
    func fetch(dates: (start: Date, end: Date)) -> [TradingLogMO] {
        fetchRequest.predicate = NSPredicate(format: "date >= %@ && date < %@",
                                             dates.start as NSDate,
                                             dates.end as NSDate)
        
        _ = dummyData.map { log in
            let object = NSEntityDescription.insertNewObject(forEntityName: "TradingLog",
                                                             into: context) as? TradingLogMO
            object?.startPrice = Int64(log.startPrice)
            object?.endPrice = Int64(log.endPrice)
            object?.date = log.date.removeTimeStamp()
            object?.rate = log.rate()
            object?.profit = Int64(log.profit())
            object?.marketState = log.change.description
            object?.memo = log.memo
        }
        
        return try! context.fetch(fetchRequest)
    }
    
    func insert(tradingLog: TradingLog) -> Bool {
        dummyData.append(tradingLog)
        return true
    }
    
    func update(tradingLog: TradingLog) -> Bool {
        var log = dummyData.first { $0.date == tradingLog.date }
        log?.startPrice = 1000
        log?.endPrice = 3000
        return true
    }
    
    func delete(date: Date) -> Bool {
        dummyData = dummyData.filter { $0.date != date.removeTimeStamp() }
        return true
    }
    
    func findTradingLog(date: Date) -> TradingLogMO? {
        return nil
    }
    
    func isExistLog(date: Date) -> Bool {
        return true
    }
    
    private func dummyInsert() {
        for i in 0..<3 {
            let date = Calendar.current.date(byAdding: .day, value: 0 - i, to: Date()) ?? .init()
            let log: TradingLog = .init(startPrice: 0,
                                        endPrice: i,
                                        date: date.removeTimeStamp(),
                                        memo: "")
            dummyData.append(log)
        }
    }
}
