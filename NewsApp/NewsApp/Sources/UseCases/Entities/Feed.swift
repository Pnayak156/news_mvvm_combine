//
//  Feed.swift
//  NewsApp
//
//  Created by Prashanta Kumar Nayak on 21/06/21.
//

import Foundation

struct Feed {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}

struct Source {
    let id: String?
    let name: String?
}

extension Source: Decodable {}
extension Feed: Decodable {}



