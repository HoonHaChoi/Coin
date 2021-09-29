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
    private var cancell: Set<AnyCancellable>
    
    init(usecase: SearchUseCase) {
        self.searchUseCase = usecase
        self.token = Messaging.messaging().fcmToken ?? ""
        self.cancell = .init()
    }
    
    var notificationsHandler: (([Notice]) -> ())?
    var loadingHiddenStateHandler: ((Bool) -> Void)?
    var errorHandler: ((NetworkError) -> ())?
    var completeMessageHanlder: ((String) -> ())?
    
    func fetchNotifications() {
        loadingHiddenStateHandler?(false)
        searchUseCase.requestNotifications(url: Endpoint.notificationsURL(token: token))
            .sink { [weak self] fail in
                if case .failure(let error) = fail {
                    self?.errorHandler?(error)
                    self?.loadingHiddenStateHandler?(true)
                }
            } receiveValue: { [weak self] notifications in
                self?.notificationsHandler?(notifications)
                self?.loadingHiddenStateHandler?(true)
            }.store(in: &cancell)
    }
    
    func deleteNotification(uuid: String) {
        loadingHiddenStateHandler?(false)
        searchUseCase.requestDeleteNotification(url: Endpoint.notificationsURL(token: uuid), method: .delete)
            .sink { [weak self] fail in
                if case .failure(let error) = fail {
                    self?.errorHandler?(error)
                    self?.loadingHiddenStateHandler?(true)
                }
            } receiveValue: { [weak self] message in
                self?.completeMessageHanlder?(message)
                self?.fetchNotifications()
            }.store(in: &cancell)
    }
    
    func updateNotificationSwitch(uuid: String, state: Bool) {
        
    }
}
