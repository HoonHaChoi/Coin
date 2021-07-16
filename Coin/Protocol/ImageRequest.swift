//
//  ImageRequest.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/16.
//

import Foundation
import Combine

protocol ImageRequset {
    func request(url: URL) -> AnyPublisher<Data, Never>
}
