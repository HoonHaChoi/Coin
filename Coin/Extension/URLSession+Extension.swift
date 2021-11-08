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
                    return Fail(error: NetworkError.invalidStatusCode(data)).eraseToAnyPublisher()
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
                    return Fail(error: NetworkError.invalidStatusCode(data)).eraseToAnyPublisher()
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
            .mapError { _ in
                NetworkError.invalidRequest
            }
            .flatMap { (data, response) -> AnyPublisher<Void, NetworkError> in
                guard let httpresponse = response as? HTTPURLResponse else {
                    return Fail(error: NetworkError.invalidResponse).eraseToAnyPublisher()
                }
                guard 200..<300 ~= httpresponse.statusCode else {
                    return Fail(error: NetworkError.invalidStatusCode(data)).eraseToAnyPublisher()
                }
                return Just(()).setFailureType(to: NetworkError.self).eraseToAnyPublisher()
            }.eraseToAnyPublisher()
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
