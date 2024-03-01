//
//  FeedCacheHelpers.swift
//  EssentialFeedPracticeApp
//
//  Created by Eric Mentele on 2/29/24.
//

import Foundation
import EssentialFeedPracticeApp

func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
    let models = [uniqueImage(), uniqueImage()]
    let localItems = models.map { LocalFeedImage(
        id: $0.id,
        description: $0.description,
        location: $0.location,
        url: $0.url
    )}
    return (models, localItems)
}

func uniqueImage() -> FeedImage {
    return FeedImage(
        id: UUID(),
        description: nil,
        location: nil,
        url: anyURL()
    )
}

// MARK: - Cache Policy Date Helper

extension Date {
    func minusFeedCacheMaxAge() -> Date {
        return adding(days: -feedCacheMaxAgeInDays)
    }

    private func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }

    private var feedCacheMaxAgeInDays: Int {
        return 7
    }
}

// MARK: - Shared Date Helpers

extension Date {
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
