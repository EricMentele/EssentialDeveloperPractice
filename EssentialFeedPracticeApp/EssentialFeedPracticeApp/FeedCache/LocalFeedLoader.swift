//
//  LocalFeedLoader.swift
//  EssentialFeedPracticeApp
//
//  Created by Eric Mentele on 2/23/24.
//

import Foundation

public final class LocalFeedLoader {
    public typealias SaveResult = Error?
    public typealias LoadResult = LoadFeedResult
    
    private let store: FeedStore
    private let currentDate: () -> Date
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { error in
            if let error {
                completion(.failure(error))
            }
        }
    }
    
    public func save(_ items: [FeedImage], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedFeed { [weak self] error in
            guard let self else { return }
            
            if let cacheDeletionError = error {
                completion(cacheDeletionError)
            } else {
                cache(items: items, with: completion)
            }
        }
    }
}

// MARK: - Helpers

private extension LocalFeedLoader {
    func cache(items: [FeedImage], with completion: @escaping (SaveResult) -> Void) {
        store.insert(items.toLocal(), timestamp: self.currentDate()) { [weak self] cacheInsertionError in
            guard self != nil else { return }
            completion(cacheInsertionError)
        }
    }
}

private extension Array where Element == FeedImage {
    func toLocal() -> [LocalFeedImage] {
        map { LocalFeedImage(
            id: $0.id,
            description: $0.description,
            location: $0.location,
            url: $0.url
        )}
    }
}
