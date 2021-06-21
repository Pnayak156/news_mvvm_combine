//
//  RepositoryMock.swift
//  NewsAppTests
//
//  Created by Prashanta Kumar Nayak on 21/06/21.
//

import Foundation
import Combine
@testable import NewsApp

final class RepositoryMock<T> {
    private let result: T
    init(_ result: T) {
        self.result = result
    }
}

extension RepositoryMock: RepositoryType where T == [Feed] {
    func loadTopHeadlines() -> AnyPublisher<[Feed], Error>  {
        .just(result)
    }
}
