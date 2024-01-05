//
//  FeedLoader.swift
//  EssentialFeedPracticeApp
//
//  Created by Eric Mentele on 12/18/23.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}

public protocol FeedLoader {
    associatedtype Error: Swift.Error
    
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
