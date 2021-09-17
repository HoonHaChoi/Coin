//
//  NotificationInputViewModel.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/10.
//

import Foundation
import Combine
import FirebaseMessaging

enum NotificationInputType {
    case basePrice
    case cycle
}

final class NotificationInputViewModel {
    
    private var basePriceText: String
    private var cycleText: String
    private let searchUseCase: SearchUseCase
    private var notificationHelper: NotificationHelp
    private var cancell: Set<AnyCancellable>
    private let token: String
    
    init(usecase: SearchUseCase,
         notificationHelper: NotificationHelp) {
        basePriceText = ""
        cycleText = ""
        self.searchUseCase = usecase
        self.notificationHelper = notificationHelper
        cancell = .init()
        token = Messaging.messaging().fcmToken ?? ""
    }
    
    var isValidCheckHandler: ((Bool) -> ())?
    var coinHandler: ((Coin) -> Void)?
    var errorHandler: ((NetworkError) -> Void)?
    var successHandler: (() -> ())?
    
    var updateNotificationInputViewHandler: ((Int, String, String) -> ())?
    
    func fetchSearchCoin(uuid: String) {
        searchUseCase.requestFavoriteCoins(uuidString: uuid)
            .sink { [weak self] (fail) in
                if case .failure(let error) = fail {
                    self?.errorHandler?(error)
                }
            } receiveValue: { [weak self] (coin) in
                self?.coinHandler?(coin)
            }.store(in: &cancell)
    }
    
    func update(text: String, type: NotificationInputType) {
        switch type {
        case .basePrice:
            basePriceText = text
        case .cycle:
            cycleText = text
        }
        isValidCheckHandler?(isFormValidCheck())
    }
    
    private func isFormValidCheck() -> Bool {
        return !basePriceText.isEmpty &&
            !cycleText.isEmpty
    }
    
    func requestCreateNotification(type: String, uuid: String) {
        let url = Endpoint.notificationCreateURL(token: token)
        let data = makeNotificationObject(type: type, uuid: uuid)
        searchUseCase.requestCompleteNotification(url: url, method: .post, body: data)
            .sink { [weak self] (fail) in
                if case .failure(let error) = fail {
                    self?.errorHandler?(error)
                }
            } receiveValue: { [weak self]  in
                self?.successHandler?()
            }.store(in: &cancell)
    }
    
    private func makeNotificationObject(type: String, uuid: String) -> Data {
        
        let notificationObject =
            NotificationObject(type: notificationHelper.mapping(typeName: type),
                               basePrice: Int(basePriceText) ?? 0,
                               tickerUUID: uuid,
                               notificationCycleUUID: notificationHelper.mapping(cycleName: cycleText))
        
        guard let data = try? JSONEncoder().encode(notificationObject) else {
            return .init()
        }
        return data
    }
    
    func configureNotificationInputView(notiObject:NotificationObject, style:NotificationInputFormStyle) {
        switch style {
        case .create:
            break
        case .update:
            let typeIndex = notificationHelper.findTypeIndex(type: notiObject.type)
            basePriceText = String(notiObject.basePrice)
            cycleText = notificationHelper.mapping(cycle: notiObject.notificationCycleUUID)
            updateNotificationInputViewHandler?(typeIndex,basePriceText,cycleText)
            isValidCheckHandler?(isFormValidCheck())
        }
    }
}


