//
//  XCTestCase+FailableInsertFeedStoreSpecs.swift
//  EssentialFeedPracticeAppTests
//
//  Created by Eric Mentele on 3/5/24.
//

import XCTest
import EssentialFeedPracticeApp

extension FailableInsertFeedStoreSpecs where Self: XCTestCase {
    func testThatInsertDeliversErrorOnInsertionError(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        let insertionError = insert((uniqueImageFeed().local, Date()), to: sut)
        
        XCTAssertNotNil(insertionError, "Expected failed insertion with error")
    }
    
    func testThatInsertHasNoSideEffectsOnInsertionError(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        insert((uniqueImageFeed().local, Date()), to: sut)
        
        expect(sut, toRetrieve: .empty)
    }
}
