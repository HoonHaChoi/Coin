//
//  NotificationCycleServiceSpy.swift
//  CoinTests
//
//  Created by HOONHA CHOI on 2021/10/24.
//

import Foundation
import Combine

class NotificationCycleServiceSpy: BaseSpy, NotificationCycleService {
    
    var cycleURLPath: String?
    
    func requestNotificationCycle(url: URL?) -> AnyPublisher<[NotificationCycle], NetworkError> {
        
        cycleURLPath = url?.lastPathComponent
        
        return Future<[NotificationCycle], NetworkError> { promise in
            if self.isSuccess {
                return promise(.success(self.dummyModel.createDummyNotificationCycle()))
            }
        }.eraseToAnyPublisher()
    }
}
