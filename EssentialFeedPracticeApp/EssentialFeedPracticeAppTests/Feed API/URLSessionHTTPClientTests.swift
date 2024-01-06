//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedPracticeAppTests
//
//  Created by Eric Mentele on 1/5/24.
//

import XCTest

class URLSessionHTTPClient {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func get(from url: URL) {
        session.dataTask(with: url) { _, _, _ in }
    }
}

final class URLSessionHTTPClientTests: XCTestCase {
    
    func test_getFromURL_createsDataTaskWithURL() {
        let url = URL(string: "https://a-url.com")!
        let sessionSpy = URLSessionSpy()
        let sut = URLSessionHTTPClient(session: sessionSpy)
        
        sut.get(from: url)
        
        XCTAssertEqual(sessionSpy.requestedURLs, [url])
    }
}

// MARK: - Helpers

extension URLSessionHTTPClientTests {
    class URLSessionSpy: URLSession {
        var requestedURLs = [URL]()
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            requestedURLs.append(url)
            return FakeURLSessionDataTask()
        }
    }
    
    class FakeURLSessionDataTask: URLSessionDataTask {
        
    }
}
