//
//  NetwokManager.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/05/17.
//

import Foundation
import Combine

class NetworkManager {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func requestResource<T: Decodable>(url: String) -> AnyPublisher<T, NetworkError> {
        let decode = JSONDecoder()
        decode.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let url = URL(string: url) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        return self.session.dataTaskPublisher(for: url)
            .mapError { _ in
                NetworkError.invalidRequest
            }
            .flatMap { (data, response) -> AnyPublisher<T, NetworkError> in
                guard let httpresponse = response as? HTTPURLResponse else {
                    return Fail(error: NetworkError.invalidResponse).eraseToAnyPublisher()
                }
                
                guard 200..<300 ~= httpresponse.statusCode else {
                    return Fail(error: NetworkError.invalidStatusCode(httpresponse.statusCode)).eraseToAnyPublisher()
                }
                
                return Just(data)
                    .decode(type: T.self, decoder: decode)
                    .mapError { error -> NetworkError in
                        return NetworkError.failParsing
                    }.eraseToAnyPublisher()
                
            }.eraseToAnyPublisher()
    }
}
