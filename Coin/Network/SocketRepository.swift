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
    func removeEmitHandler(from uuids: [String])
    func removeCurrentEmit(complete: (()) -> Void)
}

struct SocketRepository: SocketUseCase {
    
    private let socket:SocketRequest
    
    init(socket: SocketRequest) {
        self.socket = socket
    }
    
    func requestSocketExchange<T: Codable>(from exchange: Exchange, completion: @escaping (Result<[T], NetworkError>) -> Void) {
        let decode = JSONDecoder()
        decode.keyDecodingStrategy = .convertFromSnakeCase
    
        if socket.checkEqualEvent(event: [exchange.title]) {
            return
        }

        socket.joinEmit(event: exchange.title)
        socket.onEvent(exchange.title) { data, ack in
            do {
                let data = try JSON(data[0]).rawData()
                let codabledata = try decode.decode([T].self,
                                                from: data)
                completion(.success(codabledata))
            } catch {
                completion(.failure(.invalidResponse))
            }
        }
    }
    
    func requestSocketUUIDS<T: Codable>(from uuids: [String], completion: @escaping (Result<[T], NetworkError>) -> Void) {
        let decode = JSONDecoder()
        decode.keyDecodingStrategy = .convertFromSnakeCase

        if socket.checkEqualEvent(event: uuids) {
            return
        }
        
        uuids.forEach { id in
            socket.joinEmit(event: id)
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
    }
    
    func removeEmitHandler(from uuids: [String]) {
        uuids.forEach { event in
            socket.leaveEmit(event: event)
        }
    }
    
    func removeCurrentEmit(complete: (()) -> Void) {
        complete(socket.leaveCurrentLeaveEmit())
    }
}

