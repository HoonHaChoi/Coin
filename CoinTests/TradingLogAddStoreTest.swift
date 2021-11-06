//
//  TradingLogAddStoreTest.swift
//  CoinTests
//
//  Created by HOONHA CHOI on 2021/11/06.
//

import XCTest
import Combine

class TradingLogAddStoreTest: XCTestCase {

    var tradingLogAddStore: TradingLogAddStore!
    var fakeAddEnvironment: FakeAddEnvironment!
    var cancell: AnyCancellable?
    
    override func setUpWithError() throws {
        fakeAddEnvironment = .init(isSuccessState: true)
        tradingLogAddStore =
            .init(state: .empty,
                  environment: .init(onDismissSubject: fakeAddEnvironment.subject,
                                   findLog: fakeAddEnvironment.fakeFindLog(date:),
                                   existDate: fakeAddEnvironment.fakeExistDate(date:),
                                   alert: .init()))
    }

    override func tearDownWithError() throws {
        fakeAddEnvironment = nil
        tradingLogAddStore = nil
        cancell = nil
    }

    func test_CorrectStartAmountInput() throws {
        let store = tradingLogAddStore
        store?.dispatch(.startAmountInput("123123"))
        XCTAssertEqual(store?.state.startAmount, "123,123")
    }

    func test_StringStartAmountInput() throws {
        let store = tradingLogAddStore
        store?.dispatch(.startAmountInput("Not Number"))
        XCTAssertEqual(store?.state.startAmount, "0")
    }
    
    func test_ManyNumberStartAmountInput() throws {
        let store = tradingLogAddStore
        store?.dispatch(.startAmountInput("1000000000000000"))
        XCTAssertEqual(store?.state.startAmount, "9,999,999,999")
    }
    
    func test_WrongStartAmountInput() throws {
        let store = tradingLogAddStore
        store?.dispatch(.startAmountInput("123abc456"))
        XCTAssertEqual(store?.state.startAmount, "123,456")
    }
    
    func test_CorrectEndAmountInput() throws {
        let store = tradingLogAddStore
        store?.dispatch(.endAmountInput("5555555"))
        XCTAssertEqual(store?.state.endAmount, "5,555,555")
    }
    
    func test_MemoInput() throws {
        let store = tradingLogAddStore
        store?.dispatch(.memoInput("memoTest"))
        XCTAssertEqual(store?.state.memo, "memoTest")
    }
   
    func test_ExistDateTrue() throws {
        let store = tradingLogAddStore
        store?.dispatch(.dateInput(.init()))
        XCTAssertEqual(store?.state.selectDate, "")
        XCTAssertNotNil(store?.state.errorAlert)
    }
    
    func test_NotExistDate() throws {
        let fakeEnvironment = FakeAddEnvironment(isSuccessState: false)
        tradingLogAddStore = .init(state: .empty,
                            environment: .init(onDismissSubject: .init(),
                                        findLog: fakeEnvironment.fakeFindLog(date:),
                                        existDate: fakeEnvironment.fakeExistDate(date:),
                                        alert: .init()))
    
        tradingLogAddStore.dispatch(.dateInput(.init()))
        XCTAssertFalse(tradingLogAddStore.state.selectDate.isEmpty)
        XCTAssertFalse(tradingLogAddStore.state.isFormValid)
    }
    
    func test_AlertDismiss() throws {
        let store = tradingLogAddStore
        store?.dispatch(.alertDismiss)
        XCTAssertNil(store?.state.errorAlert)
    }
    
    func test_IsFormValidState() throws {
        let fakeEnvironment = FakeAddEnvironment(isSuccessState: false)
        tradingLogAddStore = .init(state: .empty,
                                   environment: .init(onDismissSubject: .init(),
                                        findLog: fakeEnvironment.fakeFindLog(date:),
                                        existDate: fakeEnvironment.fakeExistDate(date:),
                                        alert: .init()))
        
        tradingLogAddStore.dispatch(.dateInput(.init()))
        XCTAssertFalse(tradingLogAddStore.state.isFormValid)
        
        tradingLogAddStore.dispatch(.startAmountInput("123"))
        XCTAssertFalse(tradingLogAddStore.state.isFormValid)
        
        tradingLogAddStore.dispatch(.endAmountInput("321"))
        XCTAssertTrue(tradingLogAddStore.state.isFormValid)
    }
    
    func test_fakeEditInput() throws {
        let store = tradingLogAddStore
        store?.dispatch(.editInput(.init()))
        XCTAssertEqual(store?.state.selectDate, "")
        XCTAssertEqual(store?.state.startAmount, "")
        XCTAssertEqual(store?.state.endAmount, "")
        XCTAssertEqual(store?.state.isFormValid, false)
        XCTAssertEqual(store?.state.memo, "")
    }
    
    func test_CorrectAddTradingLog() throws {
        let store = tradingLogAddStore
        let memo = "AddAction"
        
        store?.dispatch(.startAmountInput("123"))
        store?.dispatch(.endAmountInput("456"))
            
        cancell = fakeAddEnvironment.subject.sink { log in
            XCTAssertEqual(log.startPrice, 123)
            XCTAssertEqual(log.endPrice, 456)
            XCTAssertEqual(log.memo, memo)
        }
        
        store?.dispatch(.addTradingLog(memo))
    }
    
    func test_WrongAddTradingLog() throws {
        let store = tradingLogAddStore
        let memo = "AddAction"
        
        store?.dispatch(.startAmountInput("12300000000000000"))
        store?.dispatch(.endAmountInput("qweqwe"))
            
        cancell = fakeAddEnvironment.subject.sink { log in
            XCTAssertEqual(log.startPrice, 9999999999)
            XCTAssertEqual(log.endPrice, 0)
            XCTAssertEqual(log.memo, memo)
        }
        
        store?.dispatch(.addTradingLog(memo))
    }
}


