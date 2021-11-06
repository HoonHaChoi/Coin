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
    
    override func setUpWithError() throws {
        fakeAddEnvironment = .init(isSuccessState: true)
        tradingLogAddStore =
            .init(state: .empty,
                environment: .init(onDismissSubject: .init(),
                                   findLog: fakeAddEnvironment.fakeFindLog(date:),
                                   existDate: fakeAddEnvironment.fakeExistDate(date:),
                                   alert: .init()))
    }

    override func tearDownWithError() throws {
        fakeAddEnvironment = nil
        tradingLogAddStore = nil
    }

    func test_CorrectStartAmountInput() throws {
        let store = tradingLogAddStore
        tradingLogAddStore.dispatch(.startAmountInput("123123"))
        XCTAssertEqual(store?.state.startAmount, "123,123")
    }

    func test_StringStartAmountInput() throws {
        let store = tradingLogAddStore
        tradingLogAddStore.dispatch(.startAmountInput("Not Number"))
        XCTAssertEqual(store?.state.startAmount, "0")
    }
    
    func test_ManyNumberStartAmountInput() throws {
        let store = tradingLogAddStore
        tradingLogAddStore.dispatch(.startAmountInput("1000000000000000"))
        XCTAssertEqual(store?.state.startAmount, "9,999,999,999")
    }
    
    func test_WrongStartAmountInput() throws {
        let store = tradingLogAddStore
        tradingLogAddStore.dispatch(.startAmountInput("123abc456"))
        XCTAssertEqual(store?.state.startAmount, "123,456")
    }
    
    func test_CorrectEndAmountInput() throws {
        let store = tradingLogAddStore
        tradingLogAddStore.dispatch(.endAmountInput("5555555"))
        XCTAssertEqual(store?.state.endAmount, "5,555,555")
    }
    
    func test_MemoInput() throws {
        let store = tradingLogAddStore
        tradingLogAddStore.dispatch(.memoInput("memoTest"))
        XCTAssertEqual(store?.state.memo, "memoTest")
    }
}


