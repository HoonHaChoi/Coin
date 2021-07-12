//
//  Coordinator.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/13.
//

import Foundation

protocol Coordinator {
    func start()
    func coordinate(to coordinator: Coordinator)
}

extension Coordinator {
    func coordinate(to coordinator: Coordinator) {
        coordinator.start()
    }
}
