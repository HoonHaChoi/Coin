//
//  NWMonitor.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/10/09.
//

import Foundation
import Network

protocol NetWorkChecking {
    func canNetworkConnect() -> Bool
}

final class NWMonitor: NetWorkChecking {
    
    private let moniter: NWPathMonitor
    private var isNetworkState: NWPath.Status
    
    init() {
        moniter = NWPathMonitor()
        isNetworkState = .unsatisfied
        setNetworkState()
    }
    
    private func setNetworkState() {
        moniter.start(queue: DispatchQueue.global())
        moniter.pathUpdateHandler = { [weak self] path in
            self?.isNetworkState = path.status
        }
    }
    
    func canNetworkConnect() -> Bool {
        return isNetworkState == .satisfied ? true : false
    }
}
