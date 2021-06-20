//
//  RequestConvertible.swift
//  NewsApp
//
//  Created by Prashanta Kumar Nayak on 20/06/21.
//

import Foundation

enum APIError: Error {
    case invalidRequest
    case invalidResponse
    case jsonDecodingError(error: Error)
    case dataloadingError(statusCode: Int, data: Data)
}

enum APIConstants {
    enum Production {
        static let baseURL = URL(string: "https://newsapi.org/v2")!
    }
    static let headlines = "top-headlines"
}

protocol RequestConvertible {
    func asURLRequest() throws -> URLRequest
}

typealias Parameters = [String: CustomStringConvertible]

enum HTTPMethod: String {
    case get = "GET"
}

protocol APIConfiguration: RequestConvertible {
    
    static var baseURL: URL { get set }
    var httpMethod: HTTPMethod { get }
    var queryParameter: Parameters { get }
    var body: Parameters { get }
    var path: String { get }
    
}

extension APIConfiguration {
    
    var httpMethod: HTTPMethod {
        .get
    }
    
    var queryParameter: Parameters {
        [:]
    }
    
    var body: Parameters {
        [:]
    }
    
    func asURLRequest() throws -> URLRequest {
        guard var components = URLComponents(url: Self.baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: true) else {
            throw APIError.invalidRequest
        }
        
        let queryItems = queryParameter.compactMap { param -> URLQueryItem? in
            URLQueryItem(name: param.key, value: param.value.description)
        }
        
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        
        guard let url = components.url else {
            throw APIError.invalidRequest
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        
        if !body.isEmpty {
            let data = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            request.httpBody = data
        }
        
        return request
    }
}




