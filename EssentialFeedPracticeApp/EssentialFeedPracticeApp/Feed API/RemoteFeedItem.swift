//
//  RemoteFeedItem.swift
//  EssentialFeedPracticeApp
//
//  Created by Eric Mentele on 2/27/24.
//

import Foundation

internal struct RemoteFeedItem: Decodable {
    internal let id: UUID
    internal let description: String?
    internal let location: String?
    internal let image: URL
}
