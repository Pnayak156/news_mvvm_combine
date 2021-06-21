//
//  APIClientMock.swift
//  NewsAppTests
//
//  Created by Prashanta Kumar Nayak on 21/06/21.
//

import Foundation
import Combine
@testable import NewsApp

final class APIClientMock<T> {
    private let response: T
    init(_ response: T) {
        self.response = response
    }
}

extension APIClientMock: DataSource where T == [Feed] {
    func loadTopHeadlines() -> AnyPublisher<[Feed], Error>  {
        .just(response)
    }
}
