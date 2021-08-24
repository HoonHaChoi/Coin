//
//  MainRepository.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/27.
//

import Foundation
import SwiftyJSON

protocol SocketUseCase {
    func requestSocketExchange<T: Codable>(from exchange: Exchange, completion: @escaping (Result<[T], NetworkError>) ->())
}

struct SocketRepository: SocketUseCase {
    
    private let socket:SocketRequest
    
    init(socket: SocketRequest) {
        self.socket = socket
    }
    
    func requestSocketExchange<T: Codable>(from exchange: Exchange, completion: @escaping (Result<[T], NetworkError>) -> Void) {
        let decode = JSONDecoder()
        decode.keyDecodingStrategy = .convertFromSnakeCase
    
        socket.onEvent(exchange.toString) { data, ack in
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
    
//    func requestUUID<T: Codable>(uuid: [String], completion: @escaping (Result<[T], NetworkError>) -> Void) {
//        let decode = JSONDecoder()
//        decode.keyDecodingStrategy = .convertFromSnakeCase
//
//        uuid.forEach { id in
//            socket.onEvent(id) { data, act in
//                do {
//                    let data = try JSON(data).rawData()
//                    let codabledata = try decode.decode([T].self,
//                                                    from: data)
//                    completion(.success(codabledata))
//                } catch {
//                    completion(.failure(.invalidResponse))
//                }
//            }
//        }
//        socket.connect()
//    }
}

