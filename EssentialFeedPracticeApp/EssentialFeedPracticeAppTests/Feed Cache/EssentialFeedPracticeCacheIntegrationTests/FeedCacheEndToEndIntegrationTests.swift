//
//  FeedCacheEndToEndIntegrationTests.swift
//  EssentialFeedPracticeCacheIntegrationTests
//
//  Created by Eric Mentele on 3/6/24.
//

import XCTest
import EssentialFeedPracticeApp

final class FeedCacheEndToEndIntegrationTests: XCTestCase {
    func test_load_deliversNoItemsOnEmptyCache() {
        let sut = makeSUT()
        let exp = expectation(description: "Wait for load to finish.")
        
        sut.load { result in
            switch result {
                
            case let .success(feed):
                XCTAssertEqual(feed, [], "Expected empty feed and got \(feed)")
            case let .failure(error):
                XCTFail("Expected successful feed result and got error: \(error)")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
}

// MARK: Helpers

private extension FeedCacheEndToEndIntegrationTests {
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> LocalFeedLoader {
        let storeBundle = Bundle(for: CoreDataFeedStore.self)
        let storeURL = testSpecificStoreURL()
        let store = try! CoreDataFeedStore(storeURL: storeURL, bundle: storeBundle)
        let sut = LocalFeedLoader(store: store, currentDate: Date.init)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func testSpecificStoreURL() -> URL {
        return cachesDirectory().appendingPathComponent("\(type(of: self)).store")
    }
    
    private func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}
