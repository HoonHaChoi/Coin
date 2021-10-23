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
}
