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


struct EnvironmentInfo {
    let baseURL: URL
}

enum APIConstants {
    
    enum Environment {
        case production(info: EnvironmentInfo)
        case development(info: EnvironmentInfo)
        
        var info: EnvironmentInfo {
            switch self {
            case let .production(envInfo), let .development(envInfo):
                return envInfo
            }
        }
    }
    
    static var currentEnvironemt = Environment.production(info: EnvironmentInfo(baseURL: URL(string: "https://newsapi.org/v2")!))
    
    static let headlines = "top-headlines"
}

protocol RequestConvertible {
    associatedtype DecodableType: Decodable
    func asURLRequest() throws -> URLRequest
}

typealias Parameters = [String: CustomStringConvertible]

enum HTTPMethod: String {
    case get = "GET"
}

protocol APIConfiguration: RequestConvertible {
    
    var baseURL: URL { get }
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
    
    var baseURL: URL {
        APIConstants.currentEnvironemt.info.baseURL
    }
    
    func asURLRequest() throws -> URLRequest {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: true) else {
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




