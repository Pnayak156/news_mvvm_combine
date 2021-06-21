//
//  RepositoryTest.swift
//  NewsAppTests
//
//  Created by Prashanta Kumar Nayak on 21/06/21.
//

import XCTest
import Combine
@testable import NewsApp


class RepositoryTest: XCTestCase {
    var cancellables = [AnyCancellable]()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRepositoryTopHeadlinesLoadSuccessfully() throws {
        let expectation = self.expectation(description: "RepositoryExpectation")
       let expectedResult = [Feed(source: Source(id: nil, name: "Channel1"), author: nil, title: "Hot News", description: nil, url: nil, urlToImage: nil, publishedAt: "", content: nil)]
        let apiClientMock = APIClientMock(expectedResult)
        let repository = Repository(networkDataSource: apiClientMock)
        
        var result: Result<[Feed], Error>?
        repository
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
