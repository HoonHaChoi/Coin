//
//  CoinTests.swift
//  CoinTests
//
//  Created by HOONHA CHOI on 2021/09/23.
//

import XCTest
import Combine

class NetworkManagerTest: XCTestCase {
    
    private var cancellable = Set<AnyCancellable>()
    private var successStub: Requestable!
    private var failStub: Requestable!
    
    override func setUp() {
        self.successStub = NetworkManagerStub(isSuccess: true)
        self.failStub = NetworkManagerStub(isSuccess: false)
    }
    
    override func tearDown() {
        self.successStub = nil
        self.failStub = nil
    }
    
    func test_RequestCoin() {
        // given
        let network = NetworkManager(session: successStub)
        
        // when
        network.requestFavoriteCoins(uuidString: "fake").sink { fail in
            if case .failure(let error) = fail {
                XCTFail(error.description)
            }
        } receiveValue: { coin in
            // then
            XCTAssertEqual("", coin.uuid)
            XCTAssertEqual("", coin.ticker)
            XCTAssertNil(coin.logo)
        }.store(in: &cancellable)
    }
    
    func test_RequestCoinFail() {
        // given
        let network = NetworkManager(session: failStub)
        
        // when
        network.requestFavoriteCoins(uuidString: "fake").sink { fail in
            // then
            if case .failure(let error) = fail {
                XCTAssertEqual(error, NetworkError.invalidResponse)
            }
        } receiveValue: { _ in
            XCTFail("Success is Fail")
        }.store(in: &cancellable)
    }
    
    func test_RequestComplete() {
        // given
        let network = NetworkManager(session: successStub)
        
        // when
        network.requestCompleteNotification(
            url: nil,
            method: .post,
            body: .init()).sink { fail in
                if case .failure(_) = fail {
                    XCTFail("Test Fail")
                }
        } receiveValue: { result in
            // then
            XCTAssertTrue(() == result)
        }.store(in: &cancellable)
    }
    
    func test_RequestDelete() {
        // given
        let network = NetworkManager(session: successStub)
        
        // when
        network.requestDeleteNotification(url: nil,
                                          method: .delete)
            .sink { fail in
                if case .failure(_) = fail {
                    XCTFail("test Fail")
                }
            } receiveValue: { result in
                // then
                XCTAssertEqual("Success", result)
            }.store(in: &cancellable)
    }
}
