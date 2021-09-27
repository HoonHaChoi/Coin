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
    
    func test_RequestCoin() {
        // given
        let stub = NetworkManagerStub(isSuccess: true)
        let network = NetworkManager(session: stub)
        
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
        let stub = NetworkManagerStub(isSuccess: false)
        let network = NetworkManager(session: stub)
        
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
}
