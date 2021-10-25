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
    
    func test_SuccessRequestFavoriteCoin() {
        let fakeUUID = "fakeUUID"
        let fakeTicker = "fakeTicker"
        
        networkManager.requestFavoriteCoins(uuidString: "fake").sink { _ in }
            receiveValue: { coin in
                XCTAssertEqual(coin.uuid, fakeUUID)
                XCTAssertEqual(coin.ticker, fakeTicker)
                XCTAssertEqual(coin.meta.tradePrice, "0")
            }.store(in: &cancellable)
    }
    
    func test_FailureRequestFavoriteCoin() {
        requestableStub.isRequestSuccess = false

        networkManager.requestFavoriteCoins(uuidString: "fake").sink { fail in
            if case .failure(let error) = fail {
                XCTAssertEqual(error, NetworkError.invalidResponse)
            }
        } receiveValue: { _ in }
        .store(in: &cancellable)
    }
    
    func test_SuccessRequestSearchCoins() {
        let fakeUUID = "fakeUUID"
        let fakeTicker = "fakeTicker"
        
        networkManager.requestSearchCoins(url: nil).sink { _ in }
            receiveValue: { coins in
                
                XCTAssertEqual(coins.first?.uuid, fakeUUID)
                XCTAssertEqual(coins.first?.ticker, fakeTicker)
                XCTAssertEqual(coins.first?.meta.tradePrice, "0")
            }.store(in: &cancellable)
    }
    
    func test_FailureRequestSearchCoins() {
        requestableStub.isRequestSuccess = false

        networkManager.requestSearchCoins(url: nil).sink { fail in
            if case .failure(let error) = fail {
                XCTAssertEqual(error, NetworkError.invalidResponse)
            }
        } receiveValue: { _ in }
        .store(in: &cancellable)
    }
    
    func test_SuccessRequestNotifications() {
        let fakeNotificationUUID = "fakeNotifications"
        let fakeNotificationBasePrice = "100"
        let fakeNotificationType = "up"
        
        networkManager.requestNotifications(url: nil).sink { _ in }
            receiveValue: { notifications in
                let notice = notifications.first?.notifications
                XCTAssertEqual(notice?.first?.uuid, fakeNotificationUUID)
                XCTAssertEqual(notice?.first?.basePrice, fakeNotificationBasePrice)
                XCTAssertEqual(notice?.first?.type, fakeNotificationType)
            }.store(in: &cancellable)
    }
    
    func test_FailureRequestNotifications() {
        requestableStub.isRequestSuccess = false

        networkManager.requestNotifications(url: nil).sink { fail in
            if case .failure(let error) = fail {
                XCTAssertEqual(error, NetworkError.invalidResponse)
            }
        } receiveValue: { _ in }
        .store(in: &cancellable)
    }
    
    func test_SuccessRequestNotificationCycle() {
        let fakeNotificationCycleFirst = "fakeCycleUUID0"
        let fakeNotificationCycleLast = "fakeCycleUUID7"
        
        networkManager.requestNotificationCycle(url: nil).sink { _ in }
            receiveValue: { notificationCycles in
                XCTAssertEqual(notificationCycles.first?.uuid, fakeNotificationCycleFirst)
                XCTAssertEqual(notificationCycles.last?.uuid, fakeNotificationCycleLast)
            }.store(in: &cancellable)
    }
    
    func test_FailureRequestNotificationCycle() {
        requestableStub.isRequestSuccess = false

        networkManager.requestNotificationCycle(url: nil).sink { fail in
            if case .failure(let error) = fail {
                XCTAssertEqual(error, NetworkError.invalidResponse)
            }
        } receiveValue: { _ in }
        .store(in: &cancellable)
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
