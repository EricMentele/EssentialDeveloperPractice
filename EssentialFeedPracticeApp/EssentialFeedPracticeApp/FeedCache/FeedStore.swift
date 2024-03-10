//
//  FeedStore.swift
//  EssentialFeedPracticeApp
//
//  Created by Eric Mentele on 2/23/24.
//

import Foundation

public typealias CachedFeed = (feed: [LocalFeedImage], timestamp: Date)

public protocol FeedStore {
    
    typealias InsertionResult = Error?
    typealias InsertionCompletion = (InsertionResult) -> Void
    
    typealias DeletionResult = Error?
    typealias DeletionCompletion = (DeletionResult) -> Void
    
    typealias Result = Swift.Result<CachedFeed?, Error>
    typealias RetrievalCompletion = (Result) -> Void
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func insert(_ items: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion)
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func retrieve(completion: @escaping RetrievalCompletion)
}
