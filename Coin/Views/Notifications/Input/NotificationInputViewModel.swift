//
//  NotificationInputViewModel.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/10.
//

import Foundation
import Combine

enum NotificationInputType {
    case basePrice
    case cycle
}

enum NotificationInputFormStyle {
    case create
    case update
}

final class NotificationInputViewModel: NotificationBaseViewModel {
    
    private var basePriceText: String
    private var cycleText: String
    private var notificationHelper: NotificationHelp
    
    init(service: NotificationNetworkService, notificationHelper: NotificationHelp, fcmToken: String) {
        self.basePriceText = ""
        self.cycleText = ""
        self.notificationHelper = notificationHelper
        super.init(service: service, fcmToken: fcmToken)
    }
    
    var isValidCheckHandler: ((Bool) -> ())?
    var coinHandler: ((Coin) -> Void)?
    var successHandler: (() -> ())?
    var updateNotificationInputViewHandler: ((Int, String, String) -> ())?
    
    func fetchSearchCoin(uuid: String) {
        requestCoin(uuid: uuid)
            .sink { [weak self] (fail) in
                if case .failure(let error) = fail {
                    self?.errorHandler?(error)
                }
            } receiveValue: { [weak self] (coin) in
                self?.coinHandler?(coin)
            }.store(in: &cancellable)
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
        return !basePriceText.isEmpty && !cycleText.isEmpty
    }
        
    func makeRequestNotification(priceType: String, uuid: String, formStyle: NotificationInputFormStyle) {
        switch formStyle {
        case .create:
            let url = Endpoint.notificationURL(type: .create(token))
            let data = makeNotificationObject(type: priceType, uuid: uuid)
            requestNotification(url: url, method: .post, body: data)
        case .update:
            let url = Endpoint.notificationURL(type: .api(uuid))
            let data = makeNotificationObject(type: priceType, uuid: "")
            requestNotification(url: url, method: .put, body: data)
        }
    }
 
    private func requestNotification(url: URL?, method: HTTPMethod, body: Data) {
        
        requestCompleteNotification(url: url, method: method, body: body)
            .sink { [weak self] (fail) in
                if case .failure(let error) = fail {
                    self?.errorHandler?(error)
                }
            } receiveValue: { [weak self] _ in
                self?.successHandler?()
            }.store(in: &cancellable)
    }
    
    private func makeNotificationObject(type: String, uuid: String) -> Data {
        let notificationObject =
            NotificationObject(type: notificationHelper.mapping(typeName: type),
                               basePrice: basePriceText.convertRegexInt(),
                               tickerUUID: uuid,
                               notificationUUID: nil,
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
            cycleText = notiObject.notificationCycleUUID
            updateNotificationInputViewHandler?(typeIndex,basePriceText,cycleText)
            isValidCheckHandler?(isFormValidCheck())
        }
    }
}

extension NotificationInputViewModel {
    private func requestCoin(uuid: String) -> AnyPublisher<Coin, NetworkError> {
        return notificationService.requestPublisher(url: Endpoint.tickerURL(type: .favorite(uuid)))
    }
    
    private func requestCompleteNotification(url: URL?, method: HTTPMethod, body: Data) -> AnyPublisher<ResponseNotifiaction, NetworkError> {
        return notificationService.requestPublisher(url: url, method: method, body: body)
    }
}
