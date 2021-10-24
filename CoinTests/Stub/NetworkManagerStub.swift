//
//  NetworkManagerStub.swift
//  CoinTests
//
//  Created by HOONHA CHOI on 2021/09/27.
//

import Foundation
import Combine

final class NetworkManagerStub: Requestable {
    
    private let dummyCoin = Coin(uuid: "", exchange: .bithumb, ticker: "", market: "", englishName: "", meta: .init(tradePrice: "", changePrice: "", changeRate: "", accTradePrice24H: "", change: .even), logo: nil)
    private let successString = "Success"
    private let isRequestSuccess: Bool
    
    init(isSuccess: Bool) {
        self.isRequestSuccess = isSuccess
    }
    
    func requestResource<T: Decodable>(url: URL?) -> AnyPublisher<T, NetworkError> {
        return Future<T, NetworkError> { promise in
            self.isRequestSuccess ?
                promise(.success(self.dummyCoin as! T)) :
                promise(.failure(.invalidResponse))
        }.eraseToAnyPublisher()
    }
    
    func requestResource<T: Decodable>(for urlRequest: URLRequest?) -> AnyPublisher<T, NetworkError> {
        return Future<T, NetworkError> { promise in
            self.isRequestSuccess ?
                promise(.success(self.successString as! T)) :
                promise(.failure(.invalidResponse))
        }.eraseToAnyPublisher()
    }
    
    func completeResponsePublisher(for urlRequest: URLRequest?) -> AnyPublisher<Void, NetworkError> {
        return Future<Void, NetworkError> { promise in
            self.isRequestSuccess ?
                promise(.success(())) :
                promise(.failure(.invalidResponse))
        }.eraseToAnyPublisher()
    }
}
