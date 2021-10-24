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
    
    func test_WrongInputNotificationObject() {
        notificationInputViewModel.update(text: "NotNumber", type: .basePrice)
        notificationInputViewModel.makeRequestNotification(priceType: "fakePriceType", uuid: "", formStyle: .create)
    
        XCTAssertEqual(notificationInputServiceSpy.completeBodyPriceType, "")
        XCTAssertEqual(notificationInputServiceSpy.completeBodyNotificationCycleUUID, "")
        XCTAssertEqual(notificationInputServiceSpy.completeBodyBasePrice, 0)
    }
    
    func test_RequestNotificationCreateParameter() {
        let token = "fakeToken"
        let fakeType = "fakeUp"
        let fakeTickerUUID = "fakeTickerUUID"
        let fakeCycleName = "fakeCycleUUID"
        
        // given
        notificationInputViewModel.update(text: "123,123", type: .basePrice)
        notificationInputViewModel.update(text: "dummyCycleName1", type: .cycle)
        let priceTpye = "dummyPriceType1"
        
        // when
        notificationInputViewModel.makeRequestNotification(priceType: priceTpye, uuid: fakeTickerUUID, formStyle: .create)

        // then
        let completePathComponents = notificationInputServiceSpy.completeURLPathComponents ?? []
        XCTAssertTrue(completePathComponents.contains(token))
        XCTAssertEqual(notificationInputServiceSpy.completeHTTPMethod, .post)
        XCTAssertEqual(notificationInputServiceSpy.completeBodyPriceType, fakeType)
        XCTAssertEqual(notificationInputServiceSpy.completeBodyBasePrice, 123123)
        XCTAssertEqual(notificationInputServiceSpy.completeBodyTickerUUID, fakeTickerUUID)
        XCTAssertEqual(notificationInputServiceSpy.completeBodyNotificationCycleUUID, fakeCycleName)
    }
    
    func test_SuccessRequestNotificationCreate() {
        notificationInputViewModel.successHandler = {
            XCTAssertNotNil(self.notificationInputServiceSpy.successActionState,
                          "정상적으로 응답이 왔다면 Handler가 동작하는지 테스트")
        }
        notificationInputViewModel.makeRequestNotification(priceType: "", uuid: "", formStyle: .create)
    }
    
    func test_FailureRequestNotifiationCreate() {
        notificationInputServiceSpy.isSuccess = false
        
        notificationInputViewModel.errorHandler = { error in
            XCTAssertEqual(error, .invalidResponse)
        }
        
        notificationInputViewModel.makeRequestNotification(priceType: "", uuid: "", formStyle: .create)
    }
    
    func test_RequestNotificationUpdateParameter() {
        let fakeNotificationUUID = "fakeNotificationUUID"
        
        notificationInputViewModel.makeRequestNotification(priceType: "", uuid: fakeNotificationUUID, formStyle: .update)
        
        let completePathComponents = notificationInputServiceSpy.completeURLPathComponents ?? []
        XCTAssertTrue(completePathComponents.contains(fakeNotificationUUID))
        XCTAssertEqual(notificationInputServiceSpy.completeHTTPMethod, .put)
        XCTAssertEqual(notificationInputServiceSpy.completeBodyTickerUUID, "")
    }
}
