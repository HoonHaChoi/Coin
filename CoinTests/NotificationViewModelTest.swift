//
//  NotificationViewModelTest.swift
//  CoinTests
//
//  Created by HOONHA CHOI on 2021/10/22.
//

import XCTest

class NotificationViewModelTest: XCTestCase {

    var notificationViewModel: NotificationsViewModel!
    var notificationServiceSpy: NotificationServiceSpy!
    
    override func setUpWithError() throws {
        notificationServiceSpy = NotificationServiceSpy(isSuccess: true)
        notificationViewModel = NotificationsViewModel(usecase: notificationServiceSpy)
    }

    override func tearDownWithError() throws {
        notificationViewModel = nil
        notificationServiceSpy = nil
    }

    func test_ResponseSuccessNotifications() throws {
        
        notificationViewModel.notificationsHandler = { notifications in
            guard let notification = notifications.first else {
                return
            }
            XCTAssertEqual(notification.uuid, "fakeUUID")
            XCTAssertEqual(notification.exchange, "fakeExchange")
            XCTAssertEqual(notification.englishName, "fakeName")
        }
        notificationViewModel.fetchNotifications()
    }
    
    func test_ResponseSuccessDeleteMessage() throws {
        notificationViewModel.completeMessageHanlder = { message in
            XCTAssertEqual(message, "FakeDeleteSuccess")
        }
        notificationViewModel.deleteNotification(uuid: "")
    }
    
    func test_RequestDeleteParameter() {
        let uuid = "fakeNotificaonUUID"
        notificationViewModel.deleteNotification(uuid: uuid)
        XCTAssertEqual(notificationServiceSpy.deleteURLParameter, uuid)
        XCTAssertEqual(notificationServiceSpy.deleteHTTPMethod, .delete)
    }
    
    

}
