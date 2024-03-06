//
//  FeedCacheEndToEndIntegrationTests.swift
//  EssentialFeedPracticeCacheIntegrationTests
//
//  Created by Eric Mentele on 3/6/24.
//

import XCTest
import EssentialFeedPracticeApp

final class FeedCacheEndToEndIntegrationTests: XCTestCase {
    override func setUp() {
        super.setUp()
        
        emptyTestStore()
    }
    
    override func tearDown() {
        super.tearDown()
        
        emptyTestStore()
    }
    
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
    
    func test_load_deliversItemsSavedOnASeperateInstance() {
        let sutToPerformSave = makeSUT()
        let sutToPerformLoad = makeSUT()
        let feed = uniqueImageFeed().models
        
        let saveFinishExpectation = expectation(description: "Wait for save to finish")
        sutToPerformSave.save(feed) { saveError in
            XCTAssertNil(saveError)
            saveFinishExpectation.fulfill()
        }
        wait(for: [saveFinishExpectation], timeout: 1.0)
        
        let loadFinishExpectation = expectation(description: "Wait for load feed to finish")
        sutToPerformLoad.load { loadFeedResult in
            switch loadFeedResult {
            case let .success(loadedFeed):
                XCTAssertEqual(feed, loadedFeed, "Expected loaded feed to be the same as the saved: \(feed). Got \(loadedFeed)")
            case let .failure(error):
                XCTFail("Expected load, after save, to succeed Got \(error) instead.")
            }
            loadFinishExpectation.fulfill()
        }
        wait(for: [loadFinishExpectation], timeout: 1.0)
    }
}

// MARK: Helpers

private extension FeedCacheEndToEndIntegrationTests {
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> LocalFeedLoader {
        let store = createTestStore()
        let sut = LocalFeedLoader(store: store, currentDate: Date.init)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func setupEmptyStoreState() {
        emptyTestStore()
    }
    
    private func undoStoreSideEffects() {
        emptyTestStore()
    }
    
    private func emptyTestStore() {
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }
    
    private func createTestStore() -> CoreDataFeedStore {
        let storeBundle = Bundle(for: CoreDataFeedStore.self)
        let storeURL = testSpecificStoreURL()
        return try! CoreDataFeedStore(storeURL: storeURL, bundle: storeBundle)
    }
    
    private func testSpecificStoreURL() -> URL {
        return cachesDirectory().appendingPathComponent("\(type(of: self)).store")
    }
    
    private func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}
