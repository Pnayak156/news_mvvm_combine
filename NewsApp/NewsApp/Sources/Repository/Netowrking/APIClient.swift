//
//  APIClient.swift
//  NewsApp
//
//  Created by Prashanta Kumar Nayak on 20/06/21.
//

import Foundation
import Combine

final class APIClient {
    private let session: URLSession
    init(_ session: URLSession = URLSession(configuration: URLSessionConfiguration.ephemeral)) {
        self.session = session
    }
    
    func performRequest<T: Decodable>(endPoint: EndPoint<T>) -> AnyPublisher<T, Error> {
        
        guard let request = try? endPoint.asURLRequest() else {
            return .fail(APIError.invalidRequest)
        }
        
        return session
            .dataTaskPublisher(for: request)
            .mapError{ _ in APIError.invalidRequest }
            .flatMap {  data, response  -> AnyPublisher<Data, Error> in
                guard let httpResponse = response as? HTTPURLResponse else {
                    return .fail(APIError.invalidResponse)
                }
                
                guard 200 ..< 300 ~= httpResponse.statusCode else {
                    return .fail(APIError.dataloadingError(statusCode: httpResponse.statusCode, data: data))
                }
                
                return .just(data)
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        
    }
}

extension APIClient: DataSource {
    func loadTopHeadlines() -> AnyPublisher<[Feed], Error> {
        return performRequest(endPoint: EndPoint<Response<Feed>>.topHeadlines)
            .map { response -> [Feed] in
            return response.articles
        }
            .eraseToAnyPublisher()
    }
}
