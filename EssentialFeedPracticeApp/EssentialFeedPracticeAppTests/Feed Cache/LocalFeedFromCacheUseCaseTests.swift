//
//  LocalFeedFromCacheUseCaseTests.swift
//  EssentialFeedPracticeAppTests
//
//  Created by Eric Mentele on 2/28/24.
//

import XCTest
import EssentialFeedPracticeApp

final class LocalFeedFromCacheUseCaseTests: XCTestCase {
    // This is copied from CacheFeedUseCaseTests. It is DRY because this is testing a completely different context
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.recievedMessages, [])
    }
}

// MARK: - Helpers

private extension LocalFeedFromCacheUseCaseTests {
    func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        return (sut, store)
    }
}
