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
    
    var successActionState: Bool?
    
    func requestFavoriteCoins(uuidString: String) -> AnyPublisher<Coin, NetworkError> {
        favoriteCoinUUID = uuidString
        return Future<Coin, NetworkError> { promise in
            self.isSuccess ?
                promise(.success(self.dummyModel.createDummyCoin())) :
                promise(.failure(.invalidResponse))
        }.eraseToAnyPublisher()
    }
    
    func requestCompleteNotification(url: URL?, method: HTTPMethod, body: Data) -> AnyPublisher<Void, NetworkError> {
        completeURLPathComponents = url?.pathComponents
        completeHTTPMethod = method
        
        let bodyJson = try? JSONSerialization.jsonObject(with: body, options: []) as? [String: Any]
        completeBodyPriceType = bodyJson?["type"] as? String
        completeBodyBasePrice = bodyJson?["basePrice"] as? Int
        completeBodyTickerUUID = bodyJson?["tickerUUID"] as? String
        completeBodyNotificationCycleUUID = bodyJson?["notificationCycleUUID"] as? String
        
        let successActionState: () = { self.successActionState = true }()
        
        return Future<Void, NetworkError> { promise in
            self.isSuccess ?
                promise(.success((successActionState))) :
                promise(.failure(.invalidResponse))
        }.eraseToAnyPublisher()
    }
    
    
}
