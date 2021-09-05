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
}

final class Socket: SocketRequest {
    
    private var manager: SocketManager?
    private var socketClient: SocketIOClient?
    private let path = "/socket"
    
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
            self?.socketClient?.handlers.forEach { handler in
                self?.joinEmit(event: handler.event)
            }
        }
    }
    
    private func onDisConnectEvent() {
        socketClient?.on(clientEvent: .disconnect) { [weak self] _, _ in
            self?.socketClient?.handlers.forEach { handler in
                self?.leaveEmit(event: handler.event)
            }
        }
    }
    
    func connect() {
        socketClient?.connect()
    }
    
    func disconnect() {
        socketClient?.disconnect()
    }
    
    func joinEmit(event: String) {
        socketClient?.emit("joinTicker", event)
    }
    
    func leaveEmit(event: String) {
        socketClient?.emit("leaveTicker", event)
        socketClient?.off(event)
    }
}
