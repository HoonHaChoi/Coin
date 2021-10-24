//
//  NotificationInputViewModelTest.swift
//  CoinTests
//
//  Created by HOONHA CHOI on 2021/10/23.
//

import XCTest

class NotificationInputViewModelTest: XCTestCase {

    var notificationInputViewModel: NotificationInputViewModel!
    var notificationInputServiceSpy: NotificationInputServiceSpy!
    var notificationHelperStub: NotificationHelperStub!
    
    override func setUpWithError() throws {
        notificationInputServiceSpy = NotificationInputServiceSpy(isSuccess: true)
        notificationHelperStub = NotificationHelperStub()
        
        notificationInputViewModel = NotificationInputViewModel(
            usecase: notificationInputServiceSpy,
            notificationHelper: notificationHelperStub,
            fcmToken: "fakeToken")
    }

    override func tearDownWithError() throws {
        notificationInputViewModel = nil
        notificationHelperStub = nil
        notificationInputServiceSpy = nil
    }

    func test_SearchCoinURLParameter() {
        let fakeFavoriteCoinUUID = "fakeFavoriteCoin"
        notificationInputViewModel.fetchSearchCoin(uuid: fakeFavoriteCoinUUID)
        XCTAssertEqual(notificationInputServiceSpy.favoriteCoinUUID,
                       fakeFavoriteCoinUUID)
    }
    
    func test_ResponseSuccessSearchCoin() {
        notificationInputViewModel.coinHandler = { coin in
            XCTAssertEqual(coin.meta.tradePrice, "0")
            XCTAssertEqual(coin.meta.changePrice, "0")
            XCTAssertEqual(coin.meta.changeRate, "0%")
        }
        notificationInputViewModel.fetchSearchCoin(uuid: "")
    }
    
    func test_ResponseFailureSearchCoin() {
        notificationInputServiceSpy.isSuccess = false
        
        notificationInputViewModel.errorHandler = { error in
            XCTAssertEqual(error, .invalidResponse)
        }
        notificationInputViewModel.fetchSearchCoin(uuid: "")
    }

    func test_BasePirceAndCycleNameTextInputIsFull() {
        let price = "123,123"
        let cycleName = "fakeCycleName"
        notificationInputViewModel.update(text: price, type: .basePrice)
        notificationInputViewModel.isValidCheckHandler = { state in
            XCTAssertTrue(state)
        }
        notificationInputViewModel.update(text: cycleName, type: .cycle)
    }
    
    func test_BasePriceTextIsEmpty() {
        notificationInputViewModel.isValidCheckHandler = { state in
            XCTAssertFalse(state)
        }
        let price = ""
        let cycleName = "fakeCycleName"
        notificationInputViewModel.update(text: price, type: .basePrice)
        notificationInputViewModel.update(text: cycleName, type: .cycle)
    }
    
    func test_CycleNameTextIsEmpty() {
        notificationInputViewModel.isValidCheckHandler = { state in
            XCTAssertFalse(state)
        }
        let price = "123,123"
        let cycleName = ""
        notificationInputViewModel.update(text: price, type: .basePrice)
        notificationInputViewModel.update(text: cycleName, type: .cycle)
    }
    
//    func test_URL() {
//        notificationInputViewModel.update(text: "123", type: .basePrice)
//        notificationInputViewModel.update(text: "한번만 알림", type: .cycle)
//        let token = "fakeToken"
//        notificationInputViewModel.makeRequestNotification(priceType: "up", uuid: "fakeUUID", formStyle: .create)
//        notificationInputViewModel.requestCreateNotification(type: "test", uuid: "fakeUUID")
//        notificationInputViewModel.requestUpdateNotification(type: "test", uuid: "fakeUUID")
//        let completePathComponents = notificationInputServiceSpy.completeURLPathComponents ?? []
//        XCTAssertTrue(completePathComponents.contains(token))
//        XCTAssertEqual(notificationInputServiceSpy.completeHTTPMethod, .post)
//    }
}
