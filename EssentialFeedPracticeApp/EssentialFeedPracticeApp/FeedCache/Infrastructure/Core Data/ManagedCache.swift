//
//  ManagedCache.swift
//  EssentialFeedPracticeApp
//
//  Created by Eric Mentele on 3/5/24.
//

import CoreData

extension ManagedCache {
    static func find(in context: NSManagedObjectContext) throws -> ManagedCache? {
        let request = NSFetchRequest<ManagedCache>(entityName: entity().name!)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request).first
    }
    
    static func newUniqueInstance(in context: NSManagedObjectContext) throws -> ManagedCache {
        try find(in: context).map(context.delete)
        return ManagedCache(context: context)
    }
    
    var localFeed: [LocalFeedImage] {
        let local = feed?.compactMap { ($0 as? ManagedFeedImage)?.local }
        if let local = local {
            return local
        } else {
            assertionFailure("This should not have a nil feed. Storing a cache without a feed should not happen")
            return []
        }
    }
}
