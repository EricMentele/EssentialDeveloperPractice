//
//  ManagedFeedImage.swift
//  EssentialFeedPracticeApp
//
//  Created by Eric Mentele on 3/5/24.
//

import CoreData

extension ManagedFeedImage {
    static func images(from localFeed: [LocalFeedImage], in context: NSManagedObjectContext) -> NSOrderedSet {
        return NSOrderedSet(array: localFeed.map { local in
            let managed = ManagedFeedImage(context: context)
            managed.id = local.id
            managed.imageDescription = local.description
            managed.location = local.location
            managed.url = local.url
            return managed
        })
    }
    
    var local: LocalFeedImage {
        if let id = id, let url = url {
            return LocalFeedImage(id: id, description: imageDescription, location: location, url: url)
        } else {
            assertionFailure("Storeing a feed image without the id or url should not happen")
            return LocalFeedImage(id: UUID(), description: nil, location: nil, url: .init(string: "http://fake.com")!)
        }
    }
}
