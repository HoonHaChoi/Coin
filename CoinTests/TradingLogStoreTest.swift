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
    }

    func testExample() throws {
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
