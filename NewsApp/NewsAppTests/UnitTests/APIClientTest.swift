//
//  APIClientTest.swift
//  NewsAppTests
//
//  Created by Prashanta Kumar Nayak on 20/06/21.
//

import XCTest
import Combine
@testable import NewsApp

class APIClientTest: XCTestCase {
    
    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        return URLSession(configuration: config)
    }()
    
    private lazy var apiClient = APIClient(session)
    
    private var jsonData: Data {
        let url = Bundle(for: APIClientTest.self).url(forResource: "Headline", withExtension: "json")
        guard let resourseUrl = url, let data = try? Data(contentsOf: resourseUrl) else {
            XCTFail("Failed to create data object from string!")
            return Data()
        }
        return data
    }
    
    private var cancellables = [AnyCancellable]()

    override func setUpWithError() throws {
        URLProtocol.registerClass(URLProtocolMock.self)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }

    func test_headlineLoadSuccessfully() throws {
        
        
        guard let urlRequest = try? EndPoint<Response<Feed>>.topHeadlines.asURLRequest() else {
            XCTFail("Invalid url request")
            return
        }
        
        let expectation = self.expectation(description: "APIClientExpectation")
        URLProtocolMock.requestHandler = {[unowned self] request in
            let response = HTTPURLResponse(url: urlRequest.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, self.jsonData)
        }
        var result: Result<[Feed], Error>?
        let publisher = apiClient.performRequest(endPoint: EndPoint<Response<Feed>>.topHeadlines)
        publisher
            .map { response -> Result<[Feed], Error> in .success(response.articles) }
            .catch { error -> AnyPublisher<Result<[Feed], Error>, Never> in
                return .just(.failure(error))
            }
            .sink { response in
                result = response
                expectation.fulfill()
            }
            .store(in: &cancellables)
        waitForExpectations(timeout: 1.0, handler: nil)
        
        guard case .success(let feeds) = result else {
            XCTFail()
            return
        }
        XCTAssertEqual(feeds.count, 20)
        
    }
    
    func test_headlineLoadFailedWithInternalError() throws {
        
        
        guard let urlRequest = try? EndPoint<Response<Feed>>.topHeadlines.asURLRequest() else {
            XCTFail("Invalid url request")
            return
        }
        
        let expectation = self.expectation(description: "APIClientExpectationFail")
        URLProtocolMock.requestHandler = { request in
            let response = HTTPURLResponse(url: urlRequest.url!, statusCode: 500, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }
        var result: Result<[Feed], Error>?
        let publisher = apiClient.performRequest(endPoint: EndPoint<Response<Feed>>.topHeadlines)
        publisher
            .map { response -> Result<[Feed], Error> in .success(response.articles) }
            .catch { error -> AnyPublisher<Result<[Feed], Error>, Never> in
                return .just(.failure(error))
            }
            .sink { response in
                result = response
                expectation.fulfill()
            }
            .store(in: &cancellables)
        waitForExpectations(timeout: 1.0, handler: nil)
        
        guard case .failure(let error) = result,
              let apiError = error as? APIError,
              case .dataloadingError(500, _) = apiError else {
            XCTFail()
            return
        }
        
    }

}


