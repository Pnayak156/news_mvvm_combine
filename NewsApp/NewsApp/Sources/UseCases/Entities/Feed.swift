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

extension Source: Equatable {
    static func == (lhs: Source, rhs: Source) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}

extension Feed: Equatable {
    static func == (lhs: Feed, rhs: Feed) -> Bool {
        return lhs.author == rhs.author
            && lhs.author == rhs.author
            && lhs.title == rhs.title
            && lhs.description == rhs.description
            && lhs.url == rhs.url
            && lhs.urlToImage == rhs.urlToImage
            && lhs.publishedAt == rhs.publishedAt
            && lhs.content == rhs.content
    }
    
}



