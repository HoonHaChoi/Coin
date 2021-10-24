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
    
    func test_WrongTypeMapping() {
        let emptyTypeName = notificationHelper.mapping(typeName: "")
        let wrongTypeName = notificationHelper.mapping(typeName: "wrong")
        
        XCTAssertTrue(emptyTypeName.isEmpty)
        XCTAssertTrue(wrongTypeName.isEmpty)
    }
    
    func test_CorrectTypeMapping() {
        let correctUpTypeName = notificationHelper.mapping(typeName: "상승")
        let correctDownTypeName = notificationHelper.mapping(typeName: "하락")
        
        XCTAssertFalse(correctUpTypeName.isEmpty)
        XCTAssertEqual(correctUpTypeName, "up")
        XCTAssertFalse(correctDownTypeName.isEmpty)
        XCTAssertEqual(correctDownTypeName, "down")
    }

    func test_WrongCycleMapping() {
        let emptyCycleName = notificationHelper.mapping(cycleName: "")
        let wrongCycleName = notificationHelper.mapping(cycleName: "wrong")
        
        XCTAssertTrue(emptyCycleName.isEmpty)
        XCTAssertTrue(wrongCycleName.isEmpty)
    }
    
    func test_CorrectCycleMapping() {
        let correctOneminuteiCycleName = notificationHelper.mapping(cycleName: "1분마다 알림")
        let correctOneHourCycleName = notificationHelper.mapping(cycleName: "1시간마다 알림")
        
        XCTAssertEqual(correctOneminuteiCycleName, "fakeCycleUUID1")
        XCTAssertEqual(correctOneHourCycleName, "fakeCycleUUID5")
    }
    
    func test_WrongFindTypeIndex() {
        let emptyTypeIndex = notificationHelper.findTypeIndex(type: "")
        let wrongTypeIndex = notificationHelper.findTypeIndex(type: "wrong")
        
        XCTAssertEqual(emptyTypeIndex, 0)
        XCTAssertEqual(wrongTypeIndex, 0)
    }
    
    func test_CorrectFindTypeIndex() {
        let downTypeIndex = notificationHelper.findTypeIndex(type: "down")
        let upTypeIndex = notificationHelper.findTypeIndex(type: "up")
        
        XCTAssertEqual(downTypeIndex, 1)
        XCTAssertEqual(upTypeIndex, 0)
    }
}
