//
//  NotificationHelper.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/13.
//

import Foundation
import Combine

protocol NotificationHelp {
    func mapping(typeName: String) -> String
    func mapping(cycleName: String) -> String
    func findTypeIndex(type: String) -> Int
}

final class NotificationHelper: NotificationHelp {
       
    private(set) var notificationTypeNames = ["상승","하락"]
    private(set) var notificationType = ["up","down"]
    
    private(set) var cycleNames: [String] = [
        "한번만 알림",
        "1분마다 알림",
        "5분마다 알림",
        "10분마다 알림",
        "30분마다 알림",
        "1시간마다 알림",
        "4시간마다 알림",
        "하루마다 알림"
    ]
    
    private(set) var cycleUUIDs: [String] = []
    
    private let service: NetworkService
    private var cancell: AnyCancellable?
    
    private(set) lazy var typeMapper = EnumMapper(key: notificationTypeNames, item: notificationType)
    private(set) lazy var cycleMapper = EnumMapper(key: cycleNames, item: cycleUUIDs)
    
    init(service: NetworkService) {
        self.service = service
        configue()
    }
    
    private func configue() {
        cancell = requestNotificationCycle()
            .sink { _ in }
                receiveValue: { [weak self] cycles in
                    cycles.forEach { cycle in
                        self?.cycleUUIDs.append(cycle.uuid)
                    }
                }
    }
    
    private func requestNotificationCycle() -> AnyPublisher<[NotificationCycle], NetworkError> {
        return service.requestPublisher(url: Endpoint.notificationURL(type: .cycle))
    }
    
    func mapping(typeName: String) -> String {
        guard let map = self.typeMapper[typeName] else {
            return ""
        }
        return map
    }
    
    func mapping(cycleName: String) -> String {
        guard let map = self.cycleMapper[cycleName] else {
            return ""
        }
        return map
    }
    
    func findTypeIndex(type: String) -> Int {
        return notificationType.firstIndex(of: type) ?? 0
    }
    
}

