//
//  XCTestCase+FailableDeleteFeedStoreSpecs.swift
//  EssentialFeedPracticeAppTests
//
//  Created by Eric Mentele on 3/5/24.
//

import XCTest
import EssentialFeedPracticeApp

extension FailableDeleteFeedStoreSpecs where Self: XCTestCase {
    func assertThatDeleteDeliversErrorOnDeletionError(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNotNil(deletionError, "Expected cache deletion to fail")
    }
    
    func assertThatDeleteHasNoSideEffectsOnDeletionError(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        
        deleteCache(from: sut)
        
        expect(sut, toRetrieve: .empty)
    }
}
