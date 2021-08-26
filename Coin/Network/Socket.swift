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
}

final class Socket: SocketRequest {
    
    private var manager: SocketManager?
    private var socketClient: SocketIOClient?
    
    init(url: URL?) {
        configure(url: url)
    }
    
    private func configure(url: URL?) {
        guard let url = url else {
            return
        }
        self.manager = SocketManager(socketURL: url,
                                     config: [.log(false),
                                              .forceWebsockets(true),
                                              .path("/socket")])
        self.socketClient = manager?.defaultSocket
    }
    
    func onEvent(_ event: String, callback: @escaping NormalCallback) -> UUID {
        socketClient?.on(event, callback: callback) ?? .init()
    }
    
    func connect() {
        socketClient?.connect()
    }
    
    func disconnect() {
        socketClient?.disconnect()
        socketClient?.removeAllHandlers()
    }
}
