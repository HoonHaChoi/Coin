//
//  NotificationsViewModel.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/15.
//

import Foundation
import FirebaseMessaging
import Combine

final class NotificationsViewModel {
    
    private let searchUseCase: SearchUseCase
    private let token: String
    private var cancell: AnyCancellable?
    
    init(usecase: SearchUseCase) {
        self.searchUseCase = usecase
        self.token = Messaging.messaging().fcmToken ?? ""
    }
    
    var notificationsHandler: (([Notifications]) -> ())?
    var loadingHiddenStateHandler: ((Bool) -> Void)?
    var errorHandler: ((NetworkError) -> ())?
    
    func fetchNotifications() {
        cancell = searchUseCase.requestNotifications(url: Endpoint.notificationsURL(token: token))
            .sink { [weak self] fail in
                if case .failure(let error) = fail {
                    self?.errorHandler?(error)
                }
            } receiveValue: { [weak self] notifications in
                self?.notificationsHandler?(notifications)
//                self?.loadingHiddenStateHandler?(true)
            }
    }
    
}
