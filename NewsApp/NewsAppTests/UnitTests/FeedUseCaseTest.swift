//
//  FeedUseCaseTest.swift
//  NewsAppTests
//
//  Created by Prashanta Kumar Nayak on 21/06/21.
//

import XCTest
import Combine
@testable import NewsApp

class FeedUseCaseTest: XCTestCase {
    var cancellables = [AnyCancellable]()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoadTopHeadlinesSuccessfully() throws {
        let expectation = self.expectation(description: "UsecaseExpectation")
       let expectedResult = [Feed(source: Source(id: nil, name: "Channel1"), author: nil, title: "Hot News", description: nil, url: nil, urlToImage: nil, publishedAt: "", content: nil)]
        let repoMock = RepositoryMock(expectedResult)
         let feedUseCase = FeedUseCase(repository: repoMock)
        var result: Result<[Feed], Error>?
        feedUseCase
            .loadTopHeadlines()
            .map { feeds -> Result<[Feed], Error> in
                .success(feeds)
            }
            .catch { error -> AnyPublisher<Result<[Feed], Error>, Never> in
                .just(.failure(error))
            }
            .sink { res in
                result = res
                expectation.fulfill()
            }
            .store(in: &cancellables)
        self.waitForExpectations(timeout: 1.0, handler: nil)

        guard case let .success(feeds) = result else {
            XCTFail()
            return
        }

        XCTAssertEqual(feeds.count, 1)
        XCTAssertEqual(feeds[0], expectedResult[0])
    }

}
