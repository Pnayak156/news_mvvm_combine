//
//  EndPoint.swift
//  NewsApp
//
//  Created by Prashanta Kumar Nayak on 20/06/21.
//

import Foundation

enum EndPoint: APIConfiguration {
    case topHeadlines

    static var baseURL: URL = APIConstants.Production.baseURL
    var path: String {
        switch self {
        case .topHeadlines:
            return APIConstants.headlines
        }
    }
    
}
