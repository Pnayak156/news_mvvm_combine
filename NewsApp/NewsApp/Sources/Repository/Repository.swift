//
//  Repository.swift
//  NewsApp
//
//  Created by Prashanta Kumar Nayak on 21/06/21.
//

import Foundation
import Combine

protocol DataSource {
    func loadTopHeadlines() -> AnyPublisher<[Feed], Error>
}

final class Repository {
    private let networkDataSource: DataSource
    
    init(networkDataSource: DataSource) {
        self.networkDataSource = networkDataSource
    }
    
    func loadTopHeadlines() -> AnyPublisher<[Feed], Error> {
        return networkDataSource.loadTopHeadlines()
    }
}
