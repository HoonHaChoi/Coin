//
//  MainRepository.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/27.
//

import Foundation
import SwiftyJSON

protocol SocketUseCase {
    func requestSocketCoins<T: Codable>(completion: @escaping (Result<[T], NetworkError>) ->())
}

struct SocketRepository {
    
    private let socket:SocketRequest
    
    init(socket: SocketRequest) {
        self.socket = socket
    }
    
    func requestSocketCoins<T: Codable>(completion: @escaping (Result<[T], NetworkError>) -> Void) {
        let decode = JSONDecoder()
        decode.keyDecodingStrategy = .convertFromSnakeCase
    
        socket.onEvent(.tickers) { data, ack in
            do {
                let data = try JSON(data.first ?? Any.self).rawData()
                let codabledata = try decode.decode([T].self,
                                                from: data)
                completion(.success(codabledata))
            } catch {
                completion(.failure(.invalidResponse))
            }
        }
        socket.connect()
    }
}

