//
//  EssentialFeedPracticeAppTests.swift
//  EssentialFeedPracticeAppTests
//
//  Created by Eric Mentele on 12/18/23.
//

import XCTest
@testable import EssentialFeedPracticeApp

class RemoteFeedLoader {
    func load() {
        HTTPClient.shared.get(from: URL(string: "https://a-given-url.com")!)
    }
}

class HTTPClient {
    static var shared = HTTPClient()
    
    var requestedURL: URL?
    
    func get(from url: URL) -> Void {
    }
}

class HTTPClientSpy: HTTPClient {
    override func get(from url: URL) {
        self.requestedURL = url
    }
}

final class EssentialFeedPracticeAppTests: XCTestCase {
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        let sut = RemoteFeedLoader()
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }
}
