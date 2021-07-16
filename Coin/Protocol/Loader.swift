//
//  Loader.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/16.
//

import UIKit
import Combine

protocol Loader {
    func load(urlString: String) -> AnyPublisher<UIImage?, Never>
}
