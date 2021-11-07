//
//  DateManagerTest.swift
//  CoinTests
//
//  Created by HOONHA CHOI on 2021/11/07.
//

import XCTest
import Foundation

class DateManagerTest: XCTestCase {
    
    var dateManger: DateManager!

    override func setUpWithError() throws {
        dateManger = .init()
    }

    override func tearDownWithError() throws {
        dateManger = nil
    }

    func test_CurrentDateString() throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM"
        
        let expectationDateString = dateFormatter.string(from: .init())
        let currentDateString = dateManger.currentDateString()
        
        XCTAssertEqual(currentDateString, expectationDateString)
    }
    
    func test_turnOfBackward() {
        let calendar = Calendar.current
        let expectationDate = calendar.date(byAdding: .month, value: -1, to: .init())
        
        dateManger.turnOfBackward()
        
        XCTAssertEqual(dateManger.currentDate.removeTimeStamp(),
                       expectationDate?.removeTimeStamp())
    }
    
    
}
