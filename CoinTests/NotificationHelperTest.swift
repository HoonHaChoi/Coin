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

    func test_RequestCyclePath() throws {
        let cyclePath = "cycles"
        XCTAssertEqual(notificationCycleServiceSpy.cycleURLPath, cyclePath)
    }
    
    func test_SuccessRequestCycleUUIDs() {
        XCTAssertEqual(notificationHelper.cycleUUIDs.count, 8)
        XCTAssertEqual(notificationHelper.cycleUUIDs.first, "fakeCycleUUID0")
        XCTAssertEqual(notificationHelper.cycleUUIDs.last, "fakeCycleUUID7")
    }
    
    func test_WrongTypeName() {
        let emptyTypeName = notificationHelper.mapping(typeName: "")
        let wrongTypeName = notificationHelper.mapping(typeName: "test")
        
        XCTAssertTrue(emptyTypeName.isEmpty)
        XCTAssertTrue(wrongTypeName.isEmpty)
    }

}
