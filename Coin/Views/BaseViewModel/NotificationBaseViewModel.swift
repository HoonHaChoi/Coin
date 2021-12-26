//
//  NotificationBaseViewModel.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/12/26.
//

import Foundation
import Combine

class NotificationBaseViewModel {
    
    private(set) var notificationService: NotificationNetworkService
    var cancellable: Set<AnyCancellable>
    private(set) var token: String
    
    init(service: NotificationNetworkService, fcmToken: String) {
        self.notificationService = service
        self.token = fcmToken
        self.cancellable = .init()
    }
    
    var errorHandler: ((NetworkError) -> Void)?
}
