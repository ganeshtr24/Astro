//
//  EndPoint.swift
//  Astro
//
//  Created by Ganesh TR on 21/03/23.
//

import Foundation

enum HTTPMethodType: String {
    case get = "GET"
}

enum RequestGenerationError: Error {
    case components
}

protocol Requestable {
    var path: String { get }
    var isFullPath: Bool { get }
    var method: HTTPMethodType { get }
    var queryParametersEncodable: Encodable? { get }
    var queryParameters: [String: Any] { get }
    func urlRequest(with networkConfig: NetworkConfigurable) throws -> URLRequest
}

protocol ResponseRequestable: Requestable {
    associatedtype Response
    
    var responseDecoder: ResponseDecoder { get }
}

class Endpoint<R>: ResponseRequestable {
    
    typealias Response = R
    
    var path: String
    var isFullPath: Bool
    var method: HTTPMethodType
    var queryParametersEncodable: Encodable? = nil
    var queryParameters: [String: Any]
    var responseDecoder: ResponseDecoder
    
    init(path: String,
         isFullPath: Bool = false,
         method: HTTPMethodType,
         queryParameters: [String: Any] = [:],
         responseDecoder: ResponseDecoder = JSONResponseDecoder()) {
        self.path = path
        self.isFullPath = isFullPath
        self.method = method
        self.queryParameters = queryParameters
        self.responseDecoder = responseDecoder
    }
}

extension Requestable {
    
    func url(with config: NetworkConfigurable) throws -> URL {
        let endpoint: String
        if isFullPath {
            endpoint = path
        } else {
            guard let bURL = config.baseURL else {
                throw RequestGenerationError.components
            }
            var baseURL = bURL.absoluteString.last != "/" ? bURL.absoluteString + "/" : bURL.absoluteString
            endpoint = baseURL.appending(path)
        }
        guard var urlComponents = URLComponents(string: endpoint) else { throw RequestGenerationError.components }
        var urlQueryItems = [URLQueryItem]()

        let queryParameters = self.queryParameters
        queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
        }
        config.queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: $0.value))
        }
        urlComponents.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        guard let url = urlComponents.url else { throw RequestGenerationError.components }
        return url
    }
    
    func urlRequest(with config: NetworkConfigurable) throws -> URLRequest {
        
        let url = try self.url(with: config)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        return urlRequest
    }
}

private extension Encodable {
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let josnData = try JSONSerialization.jsonObject(with: data)
        return josnData as? [String : Any]
    }
}
