//
//  LocalFeedLoader.swift
//  EssentialFeedPracticeApp
//
//  Created by Eric Mentele on 2/23/24.
//

import Foundation

public final class LocalFeedLoader {
    private let store: FeedStore
    private let currentDate: () -> Date
    private let calendar = Calendar(identifier: .gregorian)
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
}

extension LocalFeedLoader: FeedLoader {
    public typealias LoadResult = FeedLoader.Result
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard let self else { return }
            
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(.some((feed, timestamp))) where FeedCachePolicy.validate(timestamp, against: currentDate()):
                completion(.success(feed.toLocal()))
            case .success(.some), .success(nil):
                completion(.success([]))
            }
        }
    }
}

extension LocalFeedLoader {
    public func validateCache() {
        store.retrieve { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .failure:
                store.deleteCachedFeed { _ in }
            case let .success(.some((_, timestamp: timestamp))) where !FeedCachePolicy.validate(timestamp, against: currentDate()):
                store.deleteCachedFeed { _ in }
            case .success(nil), .success(.some): break
            }
        }
    }
}

extension LocalFeedLoader {
    public typealias SaveResult = Error?
    
    public func save(_ items: [FeedImage], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedFeed { [weak self] result in
            guard let self else { return }
            
            switch result {
            case let .failure(error):
                completion(error)
            case .success:
                cache(items: items, with: completion)
            }
        }
    }
    
    private func cache(items: [FeedImage], with completion: @escaping (SaveResult) -> Void) {
        store.insert(items.toLocal(), timestamp: self.currentDate()) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case .success:
                completion(nil)
            case let .failure(error):
                completion(error)
            }
        }
    }
}

// MARK: - Helpers

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

private extension Array where Element == LocalFeedImage {
    func toLocal() -> [FeedImage] {
        map { FeedImage(
            id: $0.id,
            description: $0.description,
            location: $0.location,
            url: $0.url
        )}
    }
}
