//
//  FeedStore.swift
//  EssentialFeedPracticeApp
//
//  Created by Eric Mentele on 2/23/24.
//

import Foundation

public protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    
    func deleteCachedFeed(completion: @escaping (Error?) -> Void)
    func insert(_ items: [LocalFeedItemDTO], timestamp: Date, completion: @escaping InsertionCompletion)
}
