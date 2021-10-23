//
//  NotificationInputServiceSpy.swift
//  CoinTests
//
//  Created by HOONHA CHOI on 2021/10/23.
//

import Foundation
import Combine

final class NotificationInputServiceSpy: BaseSpy, NotificationInputService {
    
    var favoriteCoinUUID: String?
    
    var completeURL: String?
    var completeHTTPMethod: HTTPMethod?
    
    func requestFavoriteCoins(uuidString: String) -> AnyPublisher<Coin, NetworkError> {
        favoriteCoinUUID = uuidString
        return Future<Coin, NetworkError> { promise in
            if self.isSuccess {
                promise(.success(self.dummyModel.DummyCoin()))
            } else {
                promise(.failure(.invalidResponse))
            }
        }.eraseToAnyPublisher()
    }
    
    func requestCompleteNotification(url: URL?, method: HTTPMethod, body: Data) -> AnyPublisher<Void, NetworkError> {
        completeURL = url?.lastPathComponent
        completeHTTPMethod = method
        return Future<Void, NetworkError> { promise in
            if self.isSuccess {
                promise(.success(()))
            } else {
                promise(.failure(.invalidResponse))
            }
        }.eraseToAnyPublisher()
    }
    
    
}
