//
//  TradingLogStoreTest.swift
//  CoinTests
//
//  Created by HOONHA CHOI on 2021/11/07.
//

import XCTest
import CoreData

class TradingLogStoreTest: XCTestCase {
    
    var tradingLogStore: TradingLogStore!
    var dateManagerStub: DateManagerStub!
    var coreDateStorageSpy: CoreDataStorageSpy!
    
    override func setUpWithError() throws {
        dateManagerStub = .init(succeeState: true)
        coreDateStorageSpy = .init(isSuccess: true, mockContainer: mockPersistentContainer)
        tradingLogStore = TradingLogStore(state: .empty,
                                          environment: .init(dateManager: dateManagerStub,
                                                             coreDataManager: coreDateStorageSpy,
                                                             addTradingView: .init()))
    }

    override func tearDownWithError() throws {
        tradingLogStore = nil
        dateManagerStub = nil
        coreDateStorageSpy = nil
    }

    func test_InitialLoadAction() throws {
        XCTAssertEqual(tradingLogStore.state.tradlog.count, 0)
        tradingLogStore.dispatch(.loadInitialData)
        XCTAssertEqual(tradingLogStore.state.tradlog.count, 3)
    }
    
    func test_AddLogAction() throws {
        let log: TradingLog = .init(startPrice: 333, endPrice: 444, date: .init(), memo: nil)
        tradingLogStore.dispatch(.addTradingLog(log))
        XCTAssertEqual(tradingLogStore.state.tradlog.count, 4)
    }
    
    func test_DeleteLogAction() throws {
        tradingLogStore.dispatch(.deleteTradingLog(.init()))
        XCTAssertEqual(tradingLogStore.state.tradlog.count, 2)
    }
    
    func test_UpdateLogAction() throws {
        let log: TradingLog = .init(startPrice: 1000, endPrice: 3000, date: .init().removeTimeStamp(), memo: nil)
        tradingLogStore.dispatch(.editTradingLog(log))
        
        let firstLog = tradingLogStore.state.tradlog.first
        XCTAssertEqual(firstLog?.startPrice, 1000)
        XCTAssertEqual(firstLog?.endPrice, 3000)
    }
    
    lazy var mockPersistentContainer: NSPersistentContainer = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))])!
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
}
