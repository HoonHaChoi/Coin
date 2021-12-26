//
//  NotificationsViewModel.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/15.
//

import Foundation
import Combine

final class NotificationsViewModel: NotificationBaseViewModel {
    
    var notificationsHandler: (([Notice]) -> ())?
    var loadingHiddenStateHandler: ((Bool) -> Void)?
    var completeMessageHanlder: ((String) -> ())?
    var failureIndexHandler: ((IndexPath) -> ())?
    
    func fetchNotifications() {
        loadingHiddenStateHandler?(false)
        requestNotifications()
            .sink { [weak self] fail in
                if case .failure(let error) = fail {
                    self?.errorHandler?(error)
                    self?.loadingHiddenStateHandler?(true)
                }
            } receiveValue: { [weak self] notifications in
                self?.notificationsHandler?(notifications)
                self?.loadingHiddenStateHandler?(true)
            }.store(in: &cancellable)
    }
    
    func deleteNotification(uuid: String) {
        loadingHiddenStateHandler?(false)
        requestDeleteNotification(uuid: uuid)
            .sink { [weak self] fail in
                if case .failure(let error) = fail {
                    self?.errorHandler?(error)
                    self?.loadingHiddenStateHandler?(true)
                }
            } receiveValue: { [weak self] message in
                self?.completeMessageHanlder?(message)
                self?.fetchNotifications()
            }.store(in: &cancellable)
    }
    
    func updateNotificationSwitch(uuid: String, state: Bool, indexPath: IndexPath) {
        loadingHiddenStateHandler?(false)
        requestUpdateNotificationSwitch(uuid: uuid, state: state)
            .sink { [weak self] fail in
                if case .failure(let error) = fail {
                    self?.errorHandler?(error)
                    self?.loadingHiddenStateHandler?(true)
                    self?.failureIndexHandler?(indexPath)
                }
            } receiveValue: { [weak self] _ in
                self?.loadingHiddenStateHandler?(true)
            }.store(in: &cancellable)
    }
    
    private func makeJsonData(state: Bool) -> Data {
        let dictionary = ["active": state]
        let json = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        return json ?? .init()
    }
}

extension NotificationsViewModel {
    private func requestNotifications() -> AnyPublisher<[Notice], NetworkError> {
        return notificationService.requestPublisher(url: Endpoint.notificationURL(type: .api(token)))
    }
    
    private func requestDeleteNotification(uuid: String) -> AnyPublisher<String, NetworkError> {
        return notificationService.requestPublisher(url: Endpoint.notificationURL(type: .api(uuid)), method: .delete, body: nil)
    }
    
    private func requestUpdateNotificationSwitch(uuid: String, state: Bool) -> AnyPublisher<String, NetworkError>{
        return notificationService.requestPublisher(url: Endpoint.notificationURL(type: .active(uuid)), method: .put, body: makeJsonData(state: state))
    }
}
