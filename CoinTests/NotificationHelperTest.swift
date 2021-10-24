//
//  NotificationHelperTest.swift
//  CoinTests
//
//  Created by HOONHA CHOI on 2021/10/24.
//

import XCTest

class NotificationHelperTest: XCTestCase {

    var notificationHelper: NotificationHelper!
    var notificationCycleServiceSpy: NotificationCycleServiceSpy!
    
    override func setUpWithError() throws {
        notificationCycleServiceSpy = NotificationCycleServiceSpy(isSuccess: true)
        notificationHelper = NotificationHelper(usecase: notificationCycleServiceSpy)
    }

    override func tearDownWithError() throws {
        notificationHelper = nil
        notificationCycleServiceSpy = nil
    }

    func test_CycleUUIDsCount() throws {
        
        notificationCycleServiceSpy.requestNotificationCycle(url: nil)
        
        XCTAssertEqual(notificationHelper.cycleUUIDs.count,4)
        
    }

}
