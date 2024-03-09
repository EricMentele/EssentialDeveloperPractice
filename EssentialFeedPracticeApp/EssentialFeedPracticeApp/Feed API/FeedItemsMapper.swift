//
//  FeedItemsMapper.swift
//  EssentialFeedPracticeApp
//
//  Created by Eric Mentele on 1/2/24.
//

import Foundation

 final class FeedItemsMapper {
    private struct Root: Decodable {
        let items: [RemoteFeedItem]
    }
    
    private static var OK_200: Int { return 200 }
    
     static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard let root = try? JSONDecoder().decode(Root.self, from: data), response.statusCode == OK_200 else {
            throw RemoteFeedLoader.Error.invalidData
        }
        
        return root.items
    }
}
