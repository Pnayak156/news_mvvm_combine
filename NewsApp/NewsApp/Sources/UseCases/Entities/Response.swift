//
//  Response.swift
//  NewsApp
//
//  Created by Prashanta Kumar Nayak on 21/06/21.
//

import Foundation

struct Response<Wrapped> {
    let totalResults: Int
    let articles: [Wrapped]
}

extension Response: Decodable  where Wrapped: Decodable {}
