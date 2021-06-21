//
//  EndPoint.swift
//  NewsApp
//
//  Created by Prashanta Kumar Nayak on 20/06/21.
//

import Foundation

enum EndPoint<T: Decodable>: APIConfiguration {
    case topHeadlines
    var path: String {
        switch self {
        case .topHeadlines:
            return APIConstants.headlines
        }
    }
    typealias DecodableType = T
    
}
