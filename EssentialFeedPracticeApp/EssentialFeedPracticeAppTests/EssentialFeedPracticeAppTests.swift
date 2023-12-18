//
//  EssentialFeedPracticeAppTests.swift
//  EssentialFeedPracticeAppTests
//
//  Created by Eric Mentele on 12/18/23.
//

import XCTest
@testable import EssentialFeedPracticeApp

class RemoteFeedLoader {
    
}

class HTTPClient {
    var requestedURL: URL?
}

final class EssentialFeedPracticeAppTests: XCTestCase {
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClient()
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
}
