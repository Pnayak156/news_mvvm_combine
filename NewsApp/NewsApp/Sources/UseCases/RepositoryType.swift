//
//  RepositoryType.swift
//  NewsApp
//
//  Created by Prashanta Kumar Nayak on 21/06/21.
//

import Foundation
import Combine


protocol RepositoryType {
    func loadTopHeadlines() -> AnyPublisher<[Feed], Error>
}
