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
        fakeAddEnvironment = .init()
        tradingLogAddStore =
            .init(state: .empty,
                environment: .init(onDismissSubject: .init(),
                                   findLog: fakeAddEnvironment.findLog, existDate: fakeAddEnvironment.existDate,
                                   alert: .init()))
    }

    override func tearDownWithError() throws {
        fakeAddEnvironment = nil
        tradingLogAddStore = nil
    }

    func testExample() throws {
    }

}


