//
//  Requestable.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/27.
//

import Foundation
import Combine

protocol Requestable {
    func requestResource<T: Decodable>(for urlRequest: URLRequest?) -> AnyPublisher<T, NetworkError>
}
