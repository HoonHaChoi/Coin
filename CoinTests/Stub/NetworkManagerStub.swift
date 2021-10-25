//
//  NetworkManagerStub.swift
//  CoinTests
//
//  Created by HOONHA CHOI on 2021/09/27.
//

import Foundation
import Combine

final class RequestableStub: Requestable {
    
    let dummyModels: DummyModels
    let successString = "Success"
    var isRequestSuccess: Bool
    
    init(isSuccess: Bool) {
        self.isRequestSuccess = isSuccess
        dummyModels = .init()
    }
    
    func requestResource<T: Decodable>(url: URL?) -> AnyPublisher<T, NetworkError> {
        let dummy = dummyModels.makeDummyFactory(type: T.self)
        return Future<T, NetworkError> { promise in
            self.isRequestSuccess ?
                promise(.success(dummy)) :
                promise(.failure(.invalidResponse))
        }.eraseToAnyPublisher()
    }
    
    func requestResource<T: Decodable>(for urlRequest: URLRequest?) -> AnyPublisher<T, NetworkError> {
        let dummy = dummyModels.makeDummyFactory(type: T.self)
        return Future<T, NetworkError> { promise in
            self.isRequestSuccess ?
                promise(.success(dummy)) :
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
