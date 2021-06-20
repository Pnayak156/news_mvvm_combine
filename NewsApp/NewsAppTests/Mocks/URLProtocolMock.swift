//
//  URLProtocolMock.swift
//  NewsAppTests
//
//  Created by Prashanta Kumar Nayak on 20/06/21.
//

import Foundation


typealias APIRequestHandler = (URLRequest) throws -> (HTTPURLResponse, Data?)

final class URLProtocolMock: URLProtocol {
    static var requestHandler: APIRequestHandler?
    
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override func startLoading() {
        guard let requestHandler = Self.requestHandler else {
            assertionFailure("Request handler not provided")
            return
        }
        
        do {
            let (response, data) = try requestHandler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
        //nop
    }
    
}
