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
        tradingLogCoreData = CoreDataStorageManager(container: mockPersistentContainer, userSetting: userSetting)
        calendar = Calendar.current
        dummyInsert()
    }

    override func tearDownWithError() throws {
        tradingLogCoreData = nil
        userSetting = nil
        calendar = nil
    }

    func testTradingLogFetch() throws {
        let date = calendar.date(byAdding: .month, value: -2, to: Date()) ?? .init()
        let logs = tradingLogCoreData.fetch(dates: (start: date.removeTimeStamp(),
                                          end: Date()))
        XCTAssertEqual(logs.count, 3)
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
        let date = Date()
        let calendar = Calendar.current
        
        for i in 0..<3 {
            let date = calendar.date(byAdding: .month, value: 0 - i, to: date) ?? .init()
            let log: TradingLog = .init(startPrice: 0,
                                        endPrice: i,
                                        date: date.removeTimeStamp(),
                                        memo: "")
            tradingLogCoreData.insert(tradingLog: log)
        }
    }
    
}
