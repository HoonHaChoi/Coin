//
//  CoinTests.swift
//  CoinTests
//
//  Created by HOONHA CHOI on 2021/09/23.
//

import XCTest
import Combine

class NetworkManagerTest: XCTestCase {
    
    var cancellable: Set<AnyCancellable>!
    var networkManager: NetworkManager!
    var requestableStub: RequestableStub!
    
    override func setUp() {
        requestableStub = RequestableStub(isSuccess: true)
        networkManager = NetworkManager(session: requestableStub)
        cancellable = .init()
    }
    
    override func tearDown() {
        requestableStub = nil
        networkManager = nil
        cancellable = nil
    }
    
    func test_RequestCoin() {
        // given
//        let network = NetworkManager(session: successStub)
        
        // when
        networkManager.requestFavoriteCoins(uuidString: "fake").sink { _ in
        } receiveValue: { coin in
            XCTAssertEqual("", coin.uuid)
            XCTAssertEqual("", coin.ticker)
            XCTAssertNil(coin.logo)
        }.store(in: &cancellable)

//        networkManager.requestFavoriteCoins(uuidString: "fake").sink { fail in
//            if case .failure(let error) = fail {
//                XCTFail(error.description)
//            }
//        } receiveValue: { coin in
//            // then
//            XCTAssertEqual("", coin.uuid)
//            XCTAssertEqual("", coin.ticker)
//            XCTAssertNil(coin.logo)
//        }.store(in: &cancellable)
    }
    
    func test_RequestCoinFail() {
//        // given
////        let network = NetworkManager(session: failStub)
//        requestableStub.isRequestSuccess = true
//        let rr = networkManager.requestFavoriteCoins(uuidString: "")
//        rr.sink { _ in } receiveValue: { c in
//            print(c)
//        }.store(in: &cancellable)

//        // when
//        networkManager.requestFavoriteCoins(uuidString: "fake").sink { fail in
////            // then
//            if case .failure(let error) = fail {
//                XCTAssertEqual(error, NetworkError.invalidResponse)
//            }
//            print(fail)
//        } receiveValue: { _ in }
//        .store(in: &cancellable)
    }
//
//    func test_RequestComplete() {
//        // given
////        let network = NetworkManager(session: successStub)
//
//        // when
//        networkManager.requestCompleteNotification(
//            url: nil,
//            method: .post,
//            body: .init()).sink { fail in
//                if case .failure(_) = fail {
//                    XCTFail("Test Fail")
//                }
//        } receiveValue: { result in
//            // then
//            XCTAssertTrue(() == result)
//        }.store(in: &cancellable)
//    }
//
//    func test_RequestDelete() {
//        // given
////        let network = NetworkManager(session: successStub)
//
//        // when
//        networkManager.requestDeleteNotification(url: nil,
//                                          method: .delete)
//            .sink { fail in
//                if case .failure(_) = fail {
//                    XCTFail("test Fail")
//                }
//            } receiveValue: { result in
//                // then
//                XCTAssertEqual("Success", result)
//            }.store(in: &cancellable)
//    }
}
