//
//  NotificationsViewModel.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/15.
//

import Foundation
import FirebaseMessaging

final class NotificationsViewModel {
    
    private let searchUseCase: SearchUseCase
    private let token: String
    
    init(usecase: SearchUseCase) {
        self.searchUseCase = usecase
        self.token = Messaging.messaging().fcmToken ?? ""
    }
    
    var notificationsHandler: ((Notifications) -> ())?
    var errorHandler: ((NetworkError) -> ())?
    
    func fetchNotifications() {
        
    }
    
}
