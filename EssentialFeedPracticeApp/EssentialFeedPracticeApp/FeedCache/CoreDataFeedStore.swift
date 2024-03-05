//
//  CoreDataFeedStore.swift
//  EssentialFeedPracticeApp
//
//  Created by Eric Mentele on 3/5/24.
//

import CoreData

public final class CoreDataFeedStore: FeedStore {
    public init() { }
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        
    }
    
    public func insert(_ items: [EssentialFeedPracticeApp.LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.empty)
    }
}

private extension CoreDataFeedStore {
    private class ManagedCache: NSManagedObject {
        @NSManaged var timestamp: Date
        @NSManaged var feed: NSOrderedSet
    }

    private class ManagedFeedImage: NSManagedObject {
        @NSManaged var id: UUID
        @NSManaged var imageDescription: String?
        @NSManaged var location: String?
        @NSManaged var url: URL
        @NSManaged var cache: ManagedCache
    }
}
