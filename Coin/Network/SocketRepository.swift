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
    func requestSocketUUIDS<T: Codable>(from uuids: [String], completion: @escaping (Result<[T], NetworkError>) -> ())
    func onDisConnect()
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
                let data = try JSON(data[0]).rawData()
                let codabledata = try decode.decode([T].self,
                                                from: data)
                completion(.success(codabledata))
            } catch {
                completion(.failure(.invalidResponse))
            }
        }
        socket.connect()
    }
    
    func requestSocketUUIDS<T: Codable>(from uuids: [String], completion: @escaping (Result<[T], NetworkError>) -> Void) {
        let decode = JSONDecoder()
        decode.keyDecodingStrategy = .convertFromSnakeCase

        uuids.forEach { id in
            socket.onEvent(id) { data, act in
                do {
                    let data = try JSON(data).rawData()
                    let codabledata = try decode.decode([T].self,
                                                    from: data)
                    completion(.success(codabledata))
                } catch {
                    completion(.failure(.invalidResponse))
                }
            }
        }
        socket.connect()
    }
    
    func onDisConnect() {
        socket.disconnect()
    }
}

