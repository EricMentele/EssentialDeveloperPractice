//
//  LocalFeedItemDTO.swift
//  EssentialFeedPracticeApp
//
//  Created by Eric Mentele on 2/27/24.
//

import Foundation

/// Data Transfer Object for FeedImage
public struct LocalFeedImage: Codable, Equatable {
    public let id: UUID
    public let description: String?
    public let location: String?
    public let url: URL
    
    public init(
        id: UUID,
        description: String?,
        location: String?,
        url: URL
    ) {
        self.id = id
        self.description = description
        self.location = location
        self.url = url
    }
}
