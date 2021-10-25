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
    var requestableSpy: RequestableSpy!
    
    override func setUp() {
        requestableSpy = RequestableSpy(isSuccess: true)
        networkManager = NetworkManager(session: requestableSpy)
        cancellable = .init()
    }
    
    override func tearDown() {
        requestableSpy = nil
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
        requestableSpy.isRequestSuccess = false

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
        requestableSpy.isRequestSuccess = false

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
        requestableSpy.isRequestSuccess = false

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
        requestableSpy.isRequestSuccess = false

        networkManager.requestNotificationCycle(url: nil).sink { fail in
            if case .failure(let error) = fail {
                XCTAssertEqual(error, NetworkError.invalidResponse)
            }
        } receiveValue: { _ in }
        .store(in: &cancellable)
    }
    
    func test_SuccessRequestAppStoreVersion() {
        let fakeAppVersion = "0"
        
        networkManager.requestAppStoreVersion(url: nil).sink { _ in }
            receiveValue: { appInfo in
                XCTAssertEqual(appInfo.results.first?.version, fakeAppVersion)
            }.store(in: &cancellable)
    }
    
    func test_FailureRequestAppStoreVersion() {
        requestableSpy.isRequestSuccess = false

        networkManager.requestAppStoreVersion(url: nil).sink { fail in
            if case .failure(let error) = fail {
                XCTAssertEqual(error, NetworkError.invalidResponse)
            }
        } receiveValue: { _ in }
        .store(in: &cancellable)
    }
    
    func test_SuccessRequestDeleteNotification() {
        networkManager.requestDeleteNotification(url: nil, method: .delete).sink { _ in }
            receiveValue: { resultString in
                XCTAssertEqual(resultString, "dummyString")
            }.store(in: &cancellable)
    }
    
    func test_FailureRequestDeleteNotification() {
        requestableSpy.isRequestSuccess = false
        
        networkManager.requestDeleteNotification(url: nil, method: .delete).sink { fail in
            if case .failure(let error) = fail {
                XCTAssertEqual(error, NetworkError.invalidResponse)
            }
        } receiveValue: { _ in }
        .store(in: &cancellable)
    }
    
    func test_URLNotExistRequestDeleteNotification() {
        networkManager.requestDeleteNotification(url: nil, method: .delete).sink { _ in }
            receiveValue: { _ in }.store(in: &cancellable)
        XCTAssertNil(requestableSpy.deleteURLRequest)
    }
    
    func test_URLExistRequestDeleteNotification() {
        networkManager.requestDeleteNotification(url: URL(string: "fakeURL"), method: .delete).sink { _ in }
            receiveValue: { _ in }.store(in: &cancellable)
        XCTAssertNotNil(requestableSpy.deleteURLRequest)
        XCTAssertEqual(requestableSpy.deleteHTTPMethod, "DELETE")
    }

    func test_RequestComplete() {
//        // given
////        let network = NetworkManager(session: successStub)
//
//        // when
        networkManager.requestCompleteNotification(
            url: URL(string: "fakeURL"),
            method: .post,
            body: .init()).sink { _ in }
                receiveValue: { _ in }
            .store(in: &cancellable)
    }
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
