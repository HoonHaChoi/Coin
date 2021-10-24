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
    
    var completeURLPathComponents: [String]?
    var completeHTTPMethod: HTTPMethod?
    var completeBodyPriceType: String?
    var completeBodyTickerUUID: String?
    var completeBodyBasePrice: Int?
    var completeBodyNotificationCycleUUID: String?
    
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
        completeURLPathComponents = url?.pathComponents
        completeHTTPMethod = method
        
        let bodyJson = try? JSONSerialization.jsonObject(with: body, options: []) as? [String: Any]
        print(bodyJson)
        completeBodyPriceType = bodyJson?["type"] as? String
        completeBodyBasePrice = bodyJson?["basePrice"] as? Int
        completeBodyTickerUUID = bodyJson?["tickerUUID"] as? String
        completeBodyNotificationCycleUUID = bodyJson?["notificationCycleUUID"] as? String
        
        return Future<Void, NetworkError> { promise in
            if self.isSuccess {
                promise(.success(()))
            } else {
                promise(.failure(.invalidResponse))
            }
        }.eraseToAnyPublisher()
    }
    
    
}
