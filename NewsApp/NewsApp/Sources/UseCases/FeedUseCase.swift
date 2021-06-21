//
//  FeedUseCase.swift
//  NewsApp
//
//  Created by Prashanta Kumar Nayak on 21/06/21.
//

import Foundation
import Combine

final class FeedUseCase {
    let repository: RepositoryType
    
    init(repository: RepositoryType) {
        self.repository = repository
    }
}

extension FeedUseCase: FeedUseCaseType {
    func loadTopHeadlines() -> AnyPublisher<[Feed], Error> {
        return repository.loadTopHeadlines()
    }
}

