//
//  FeedLoader.swift
//  EssentialFeedPracticeApp
//
//  Created by Eric Mentele on 12/18/23.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
