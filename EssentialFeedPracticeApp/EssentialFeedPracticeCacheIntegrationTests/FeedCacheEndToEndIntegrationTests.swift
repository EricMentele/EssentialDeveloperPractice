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
        
        expect(sut, toLoad: [])
    }
    
    func test_load_deliversItemsSavedOnASeperateInstance() {
        let sutToPerformSave = makeSUT()
        let sutToPerformLoad = makeSUT()
        let feed = uniqueImageFeed().models
        
        expect(sutToPerformSave, toSave: feed)
        
        expect(sutToPerformLoad, toLoad: feed)
    }
    
    func test_save_overridesItemsSavedOnASeparateInstance() {
        let sutToPerformFirstSave = makeSUT()
        let sutToPerformLastSave = makeSUT()
        let sutToPerformLoad = makeSUT()
        let firstFeed = uniqueImageFeed().models
        let latestFeed = uniqueImageFeed().models
        
        expect(sutToPerformFirstSave, toSave: firstFeed)
        expect(sutToPerformLastSave, toSave: latestFeed)
        
        expect(sutToPerformLoad, toLoad: latestFeed)
    }
}

// MARK: Helpers

private extension FeedCacheEndToEndIntegrationTests {
    func makeSUT(file: StaticString = #file, line: UInt = #line) -> LocalFeedLoader {
        let store = createTestStore()
        let sut = LocalFeedLoader(store: store, currentDate: Date.init)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    func expect(_ sut: LocalFeedLoader, toLoad expectedFeed: [FeedImage], file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load to finish.")
        
        sut.load { result in
            switch result {
            case let .success(feed):
                XCTAssertEqual(feed, expectedFeed, "Expected empty feed and got \(feed)")
            case let .failure(error):
                XCTFail("Expected successful feed result and got error: \(error)")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func expect(_ sut: LocalFeedLoader, toSave expectedFeed: [FeedImage], file: StaticString = #file, line: UInt = #line) {
        let saveFinishExpectation = expectation(description: "Wait for save to finish")
        sut.save(expectedFeed) { saveError in
            XCTAssertNil(saveError)
            saveFinishExpectation.fulfill()
        }
        wait(for: [saveFinishExpectation], timeout: 1.0)
    }
    
    func setupEmptyStoreState() {
        emptyTestStore()
    }
    
    func undoStoreSideEffects() {
        emptyTestStore()
    }
    
    func emptyTestStore() {
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }
    
    func createTestStore() -> CoreDataFeedStore {
        let storeBundle = Bundle(for: CoreDataFeedStore.self)
        let storeURL = testSpecificStoreURL()
        return try! CoreDataFeedStore(storeURL: storeURL, bundle: storeBundle)
    }
    
    func testSpecificStoreURL() -> URL {
        return cachesDirectory().appendingPathComponent("\(type(of: self)).store")
    }
    
    func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}
