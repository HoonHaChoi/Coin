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
        notificationViewModel = NotificationsViewModel(usecase: notificationServiceSpy,
                                                       fcmToken: "fakeToken")
    }

    override func tearDownWithError() throws {
        notificationViewModel = nil
        notificationServiceSpy = nil
    }

    func test_ResponseSuccessNotifications() throws {
        notificationViewModel.notificationsHandler = { notifications in
            if let notification = notifications.first {
                XCTAssertEqual(notification.uuid, "fakeUUID")
                XCTAssertEqual(notification.exchange, "fakeExchange")
                XCTAssertEqual(notification.englishName, "fakeName")
            }
        }
        notificationViewModel.fetchNotifications()
    }
    
    func test_ResponseSuccessDeleteNotification() throws {
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
    
    func test_RequestUpdateNotificationSwitchParameter() {
        let uuid = "fakeNotificationUUID"
        let state = false
        
        notificationViewModel.updateNotificationSwitch(uuid: uuid, state: state, indexPath: .init())
        
        XCTAssertEqual(notificationServiceSpy.completeURLParameter, uuid)
        XCTAssertEqual(notificationServiceSpy.completeHTTPMethod, .put)
        XCTAssertEqual(notificationServiceSpy.completeBody, state)
    }
    
    func test_ResponseSuccessUpdateNotificationSwitch() {
        notificationViewModel.updateNotificationSwitch(uuid: "", state: false, indexPath: .init())
        XCTAssertEqual(notificationServiceSpy.completeResponse, true)
    }
    
    func test_ResponseFailureNotifications() {
        notificationServiceSpy.isSuccess = false
        
        notificationViewModel.errorHandler = { error in
            XCTAssertEqual(error, .invalidResponse)
        }
        notificationViewModel.fetchNotifications()
    }
    
    func test_ResponseFailureDeleteNotification() {
        notificationServiceSpy.isSuccess = false
        
        notificationViewModel.errorHandler = { error in
            XCTAssertEqual(error, .invalidResponse)
        }
        notificationViewModel.deleteNotification(uuid: "")
    }
    
    func test_ResponseFailureUpdateNotificationSwitch() {
        notificationServiceSpy.isSuccess = false
        
        let indexPath: IndexPath = .init(row: 1, section: 2)
        notificationViewModel.errorHandler = { error in
            XCTAssertEqual(error, .invalidResponse)
        }
        notificationViewModel.failureIndexHandler = { indexPath in
            XCTAssertEqual(indexPath.row, 1)
            XCTAssertEqual(indexPath.section, 2)
        }
        notificationViewModel.updateNotificationSwitch(uuid: "", state: false, indexPath: indexPath)
    }
}
