//
//  CoinTests.swift
//  CoinTests
//
//  Created by HOONHA CHOI on 2021/09/23.
//

import XCTest
import Combine

class NetworkManagerTest: XCTestCase {
    
    private var stub: Requestable!
    private var network: SearchUseCase!
    private var cancellable = Set<AnyCancellable>()
    
    override func setUp() {
        self.stub = NetworkManagerStub(isSuccess: true)
        self.network = NetworkManager(session: stub)
        super.setUp()
    }

    override func tearDown() {
        self.stub = nil
        self.network = nil
        super.tearDown()
    }

    func test_RequestCoin() {
        // when
        network.requestFavoriteCoins(uuidString: "fake").sink { fail in
            if case .failure(let error) = fail {
                XCTFail(error.description)
            }
        } receiveValue: { coin in
            // then
            XCTAssertEqual("", coin.uuid)
        }.store(in: &cancellable)
    }
}
