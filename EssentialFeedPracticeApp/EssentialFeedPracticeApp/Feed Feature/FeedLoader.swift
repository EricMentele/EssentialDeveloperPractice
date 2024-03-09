//
//  FeedLoader.swift
//  EssentialFeedPracticeApp
//
//  Created by Eric Mentele on 12/18/23.
//

import Foundation

public protocol FeedLoader {
    typealias Result = Swift.Result<[FeedImage], Error>
    
    func load(completion: @escaping (Result) -> Void)
}
