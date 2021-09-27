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
        if isRequestSuccess {
            return Just(dummyCoin as! T)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        }
        return Fail(error: NetworkError.invalidResponse).eraseToAnyPublisher()
    }
    
    func requestResource<T>(for urlRequest: URLRequest?) -> AnyPublisher<T, NetworkError> where T : Decodable {
        if isRequestSuccess {
            return Just(successString as! T)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        }
        return Fail(error: NetworkError.invalidResponse).eraseToAnyPublisher()
    }
    
    func completeResponsePublisher(for urlRequest: URLRequest?) -> AnyPublisher<Void, NetworkError> {
        if isRequestSuccess {
            return Just(()).setFailureType(to: NetworkError.self).eraseToAnyPublisher()
        }
        return Fail(error: NetworkError.invalidResponse).eraseToAnyPublisher()
    }
}
