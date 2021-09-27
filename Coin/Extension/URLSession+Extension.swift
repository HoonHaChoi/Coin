import Foundation
import Combine

extension URLSession: Requestable {
    func requestResource<T: Decodable>(url: URL?) -> AnyPublisher<T, NetworkError> {
        let decode = JSONDecoder()
        decode.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let url = url else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        return self.dataTaskPublisher(for: url)
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
    
    func requestResource<T: Decodable>(for urlRequest: URLRequest?) -> AnyPublisher<T, NetworkError> {
        let decode = JSONDecoder()
        decode.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let urlRequest = urlRequest else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        return self.dataTaskPublisher(for: urlRequest)
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
    
    func completeResponsePublisher(for urlRequest: URLRequest?) -> AnyPublisher<Void, NetworkError> {
        guard let urlRequest = urlRequest else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        return self.dataTaskPublisher(for: urlRequest)
            .tryMap { _, response in
            guard let httpResponse = response as? HTTPURLResponse else { throw NetworkError.invalidResponse }
            let statusCode = httpResponse.statusCode
            guard (200..<300).contains(statusCode) else { throw NetworkError.invalidStatusCode(statusCode) }
            return
        }.mapError { _ in NetworkError.invalidResponse }
        .eraseToAnyPublisher()
    }
}

extension URLSession: ImageRequset {
    func request(url: URL) -> AnyPublisher<Data, Never> {
        self.dataTaskPublisher(for: url)
            .map { $0.data }
            .replaceError(with: Data())
            .eraseToAnyPublisher()
    }
}


extension URLSession.DataTaskPublisher {
    func completeResponsePublisher() -> AnyPublisher<Void, NetworkError> {
        tryMap { _, response in
            guard let httpResponse = response as? HTTPURLResponse else { throw NetworkError.invalidResponse }
            let statusCode = httpResponse.statusCode
            guard (200..<300).contains(statusCode) else { throw NetworkError.invalidStatusCode(statusCode) }
            return 
        }.mapError { _ in NetworkError.invalidResponse }
        .eraseToAnyPublisher()
    }
}
