//
//  NotificationServiceSpy.swift
//  CoinTests
//
//  Created by HOONHA CHOI on 2021/10/22.
//

import Foundation
import Combine

final class NotificationServiceSpy: BaseSpy, NotificationService {
   
    func requestNotifications(url: URL?) -> AnyPublisher<[Notice], NetworkError> {
    
        return Future<[Notice], NetworkError> { promise in
            if self.isSuccess {
                promise(.success([self.dummyModel.DummyNotice()]))
            } else {
                promise(.failure(.invalidResponse))
            }
        }.eraseToAnyPublisher()
    }
    
    func requestDeleteNotification(url: URL?, method: HTTPMethod) -> AnyPublisher<String, NetworkError> {
        
        return Future<String, NetworkError> { promise in
            if self.isSuccess {
                promise(.success(""))
            } else {
                promise(.failure(.invalidResponse))
            }
        }.eraseToAnyPublisher()
    }
    
    func requestCompleteNotification(url: URL?, method: HTTPMethod, body: Data) -> AnyPublisher<Void, NetworkError> {
        
        return Future<Void, NetworkError> { promise in
            if self.isSuccess {
                promise(.success(()))
            } else {
                promise(.failure(.invalidResponse))
            }
        }.eraseToAnyPublisher()
    }
}
