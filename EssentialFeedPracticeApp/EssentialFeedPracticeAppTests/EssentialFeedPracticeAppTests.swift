//
//  EssentialFeedPracticeAppTests.swift
//  EssentialFeedPracticeAppTests
//
//  Created by Eric Mentele on 12/18/23.
//

import XCTest
import EssentialFeedPracticeApp

final class EssentialFeedPracticeAppTests: XCTestCase {
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURL, url)
    }
    
    func test_loadTwice_requestDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
}

private func makeSUT(url: URL = URL(string: "https://a-given-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
    let client = HTTPClientSpy()
    let sut = RemoteFeedLoader(client: client, url: url)
    return (sut, client)
}

private class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?
    var requestedURLs = [URL]()
    
    func get(from url: URL) {
        self.requestedURL = url
        self.requestedURLs.append(url)
    }
}
