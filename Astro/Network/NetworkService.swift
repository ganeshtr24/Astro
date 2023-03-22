//
//  NetworkService.swift
//  Astro
//
//  Created by Ganesh TR on 20/03/23.
//

import Foundation

enum NetworkError: Error {
    case notConnected
    case cancelled
    case error(statusCode: Int, data: Data?)
    case generic(Error)
    case urlGeneration
}



protocol NetworkSessionManager {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    func request(_ request: URLRequest,
                 completion: @escaping CompletionHandler) -> URLSessionTask
}

class DefaultNetworkSessionManager: NetworkSessionManager {
   public init() {}
   public func request(_ request: URLRequest,
                       completion: @escaping CompletionHandler) -> URLSessionTask {
       let task = URLSession.shared.dataTask(with: request, completionHandler: completion)
       task.resume()
       return task
   }
}

protocol NetworkService {
    typealias CompletionHandler = (Result<Data?, NetworkError>) -> Void
    
    func request(endpoint: Requestable, completion: @escaping CompletionHandler)
}

final class DefaultNetworkService: NetworkService {
    private let config: NetworkConfigurable
    private let sessionManager: NetworkSessionManager
    
    init(config: NetworkConfigurable,
         sessionManager: NetworkSessionManager = DefaultNetworkSessionManager()) {
        self.config = config
        self.sessionManager = sessionManager
    }
    
    private func request(request: URLRequest, completion: @escaping CompletionHandler) {
        
        let sessionDataTask = sessionManager.request(request) { data, response, requestError in
            
            if let requestError = requestError {
                var error: NetworkError
                if let response = response as? HTTPURLResponse {
                    error = .error(statusCode: response.statusCode, data: data)
                } else {
                    error = self.resolve(error: requestError)
                }
                completion(.failure(error))
            } else {
                completion(.success(data))
            }
        }
        sessionDataTask.resume()
    }
    
    private func resolve(error: Error) -> NetworkError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code {
        case .notConnectedToInternet: return .notConnected
        case .cancelled: return .cancelled
        default: return .generic(error)
        }
    }
    
    func request(endpoint: Requestable, completion: @escaping CompletionHandler) {
        do {
            let urlRequest = try endpoint.urlRequest(with: config)
            request(request: urlRequest, completion: completion)
        } catch {
            completion(.failure(.urlGeneration))
        }
    }
}



