//
//  CoreDataStorageTest.swift
//  CoinTests
//
//  Created by HOONHA CHOI on 2021/10/03.
//

import XCTest
import CoreData

class CoreDataStorageTest: XCTestCase {

    var tradingLogCoreData: CoreDataStorageManager!
    var userSetting: UserSetting!
    var calendar: Calendar!
    
    override func setUpWithError() throws {
        userSetting = UserSetting()
        tradingLogCoreData = CoreDataStorageManager(container: mockPersistentContainer,
                                                    userSetting: userSetting)
        calendar = Calendar.current
        dummyInsert()
    }

    override func tearDownWithError() throws {
        tradingLogCoreData = nil
        userSetting = nil
        calendar = nil
    }

    func test_FetchTradingLog() {
        let date = calendar.date(byAdding: .month, value: -2, to: Date()) ?? .init()
        let logs = tradingLogCoreData.fetch(dates: (start: date.removeTimeStamp(),
                                          end: Date()))
        XCTAssertEqual(logs.count, 3)
    }
    
    func test_DeleteTradingLog() {
        let date = calendar.date(byAdding: .month, value: -2, to: Date()) ?? .init()
        _ = tradingLogCoreData.delete(date: date.removeTimeStamp())
        let logs = tradingLogCoreData.fetch(dates: (start: date.removeTimeStamp(),
                                          end: Date()))
        XCTAssertEqual(logs.count, 2)
    }
    
    func test_FindTradingLog() {
        let date = calendar.date(byAdding: .month, value: -1, to: Date()) ?? .init()
        let log = tradingLogCoreData.find(date: date.removeTimeStamp())
        
        XCTAssertEqual(log[0].endPrice, 1)
        XCTAssertEqual(log[0].date, date.removeTimeStamp())
    }
    
    func test_UpdateTradingLog() {
        let updateLog: TradingLog = .init(startPrice: 100, endPrice: 200, date: Date().removeTimeStamp(), memo: "update")
        
        _ = tradingLogCoreData.update(tradingLog: updateLog)
        let log = tradingLogCoreData.find(date: Date().removeTimeStamp())
        XCTAssertEqual(log[0].startPrice, 100)
        XCTAssertEqual(log[0].endPrice, 200)
        XCTAssertEqual(log[0].memo, "update")
    }
    
    
    lazy var mockPersistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TradingLogModel",managedObjectModel: managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { description, error in
            precondition(description.type == NSInMemoryStoreType)
            
            if error != nil {
                fatalError()
            }
        }
        return container
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
          let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))])!
          return managedObjectModel
      }()
    
    private func dummyInsert() {
        for i in 0..<3 {
            let date = calendar.date(byAdding: .month, value: 0 - i, to: Date()) ?? .init()
            let log: TradingLog = .init(startPrice: 0,
                                        endPrice: i,
                                        date: date,
                                        memo: "")
            tradingLogCoreData.insert(tradingLog: log)
        }
    }
    
}
