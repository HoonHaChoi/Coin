//
//  SocketManager.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/27.
//

import Foundation
import SocketIO

protocol SocketRequest {
    @discardableResult
    func onEvent(_ event: String, callback: @escaping NormalCallback) -> UUID
    func connect()
    func disconnect()
    func joinEmit(event: String)
    func leaveEmit(event: String)
    func checkEqualEvent(event: [String]) -> Bool
    func leaveCurrentLeaveEmit()
}

final class Socket: SocketRequest {
    
    private var manager: SocketManager?
    private var socketClient: SocketIOClient?
    private let path = "/socket"
    private let connectEventName = "connect"
    private let disconnectEventName = "disconnect"
    private let join = "join"
    private let leave = "leave"
    
    init(url: URL?) {
        configure(url: url)
        onConnectEvent()
        onDisConnectEvent()
    }
    
    private func configure(url: URL?) {
        guard let url = url else {
            return
        }
        self.manager = SocketManager(socketURL: url,
                                     config: [.log(false),
                                              .forceWebsockets(true),
                                              .path(path)])
        self.socketClient = manager?.defaultSocket
    }
    
    func onEvent(_ event: String, callback: @escaping NormalCallback) -> UUID {
        socketClient?.on(event, callback: callback) ?? .init()
    }
    
    private func onConnectEvent() {
        socketClient?.on(clientEvent: .connect) { [weak self] _, _ in
            self?.isEventHandler().forEach { handler in
                self?.joinEmit(event: handler.event)
            }
        }
    }
    
    private func onDisConnectEvent() {
        socketClient?.on(clientEvent: .disconnect) { [weak self] _, _ in
            guard let self = self else { return }
            self.isEventHandler().forEach { handler in
                self.socketClient?.emit(self.leave, handler.event)
            }
        }
    }
    
    private func isEventHandler() -> [SocketEventHandler] {
        return socketClient?.handlers.filter { $0.event != connectEventName &&
            $0.event != disconnectEventName } ?? []
    }
    
    func connect() {
        socketClient?.connect()
    }
    
    func disconnect() {
        socketClient?.disconnect()
    }
    
    func joinEmit(event: String) {
        socketClient?.emit(join, event)
    }
    
    func leaveEmit(event: String) {
        socketClient?.emit(leave, event)
        socketClient?.off(event)
    }
    
    func leaveCurrentLeaveEmit() {
        guard let handler = isEventHandler().first else {
            return
        }
        leaveEmit(event: handler.event)
    }
    
    func checkEqualEvent(event: [String]) -> Bool {
        let handler = socketClient?.handlers.map { handler in handler.event }
        let filterHandler = handler?.filter { handlerEvent in event.contains(handlerEvent) } ?? []
        return filterHandler.isEmpty ? false : true
    }
}
