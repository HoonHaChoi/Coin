//
//  NetworkManagerStub.swift
//  CoinTests
//
//  Created by HOONHA CHOI on 2021/09/27.
//

import Foundation
import Combine

final class RequestableSpy: Requestable {
    
    let dummyModels: DummyModels
    
    var isRequestSuccess: Bool
    
    var completeHTTPMethod: String?
    var completeBody: Data?
    var urlRequestContentType: String?
    var completeResponse: Bool?
    
    var deleteURLRequest: URLRequest?
    var deleteHTTPMethod: String?
    
    
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
        deleteURLRequest = urlRequest
        deleteHTTPMethod = urlRequest?.httpMethod
        return Future<T, NetworkError> { promise in
            self.isRequestSuccess ?
                promise(.success(dummy)) :
                promise(.failure(.invalidResponse))
        }.eraseToAnyPublisher()
    }
    
    func completeResponsePublisher(for urlRequest: URLRequest?) -> AnyPublisher<Void, NetworkError> {
        completeBody = urlRequest?.httpBody
        completeHTTPMethod = urlRequest?.httpMethod
        urlRequestContentType = urlRequest?.allHTTPHeaderFields?["Content-Type"]
        //application/json
        let completeStateAction: () = { self.completeResponse = true }()
        return Future<Void, NetworkError> { promise in
            self.isRequestSuccess ?
                promise(.success(completeStateAction)) :
                promise(.failure(.invalidResponse))
        }.eraseToAnyPublisher()
    }
}
