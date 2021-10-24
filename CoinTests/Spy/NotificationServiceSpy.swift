//
//  NotificationServiceSpy.swift
//  CoinTests
//
//  Created by HOONHA CHOI on 2021/10/22.
//

import Foundation
import Combine

final class NotificationServiceSpy: BaseSpy, NotificationService {
   
    var deleteURLParameter: String?
    var deleteHTTPMethod: HTTPMethod?
    
    var completeURLParameter: String?
    var completeHTTPMethod: HTTPMethod?
    var completeBody: Bool?
    var completeResponse: Bool?
    
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
        deleteURLParameter = url?.lastPathComponent
        deleteHTTPMethod = method
        return Future<String, NetworkError> { promise in
            if self.isSuccess {
                promise(.success("FakeDeleteSuccess"))
            } else {
                promise(.failure(.invalidResponse))
            }
        }.eraseToAnyPublisher()
    }
    
    func requestCompleteNotification(url: URL?, method: HTTPMethod, body: Data) -> AnyPublisher<Void, NetworkError> {
        let urlComponents = url?.path.components(separatedBy: "/")
        let bodyState = try? JSONSerialization.jsonObject(with: body, options: []) as? [String: Bool]
        completeURLParameter = urlComponents?[4]
        completeHTTPMethod = method
        completeBody = bodyState?["active"]
        return Future<Void, NetworkError> { promise in
            if self.isSuccess {
                self.completeResponse = true
                promise(.success(()))
            } else {
                promise(.failure(.invalidResponse))
            }
        }.eraseToAnyPublisher()
    }
}