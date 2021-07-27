//
//  SocketManager.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/27.
//

import Foundation
import SocketIO

final class Socket {
    
    enum Event {
        case tickers
        
        var name: String {
            switch self {
            case .tickers:
                return "tickers"
            }
        }
    }
    
    let manager: SocketManager
    let socketClient: SocketIOClient
    
    init(url: URL) {
        self.manager = SocketManager(socketURL: url,
                                     config: [.log(false),
                                              .forceWebsockets(true),
                                              .path("/socket")])
        self.socketClient = manager.defaultSocket
    }
    
    func onEvent(_ event: Event, callback: @escaping NormalCallback) -> UUID {
        socketClient.on(event.name, callback: callback)
    }
    
    func connect() {
        socketClient.connect()
    }
    
    func disconnect() {
        socketClient.disconnect()
    }
}
