//
//  RemoteFeedItem.swift
//  EssentialFeedPracticeApp
//
//  Created by Eric Mentele on 2/27/24.
//

import Foundation

 struct RemoteFeedItem: Decodable {
     let id: UUID
     let description: String?
     let location: String?
     let image: URL
}
