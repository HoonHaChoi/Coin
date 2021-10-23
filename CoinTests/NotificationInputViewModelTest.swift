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
            notificationHelper: notificationHelperStub)
    }

    override func tearDownWithError() throws {
        notificationInputViewModel = nil
        notificationHelperStub = nil
        notificationInputServiceSpy = nil
    }

    func testExample() throws {
        
    }

}
