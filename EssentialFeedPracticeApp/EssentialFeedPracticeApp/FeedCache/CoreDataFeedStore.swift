//
//  CoreDataFeedStore.swift
//  EssentialFeedPracticeApp
//
//  Created by Eric Mentele on 3/5/24.
//

import CoreData

public final class CoreDataFeedStore: FeedStore {
    private let container: NSPersistentContainer
    
    private let context: NSManagedObjectContext
    
    public init(storeURL: URL, bundle: Bundle = .main) throws {
        container = try NSPersistentContainer.load(modelName: "FeedStore", in: bundle, url: storeURL)
        context = container.newBackgroundContext()
    }
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        
    }
    
    public func insert(_ items: [EssentialFeedPracticeApp.LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        
        let context = self.context
        context.perform {
            do {
                let managedCache = ManagedCache(context: context)
                managedCache.timestamp = timestamp
                managedCache.feed = NSOrderedSet(array: items.map { local in
                    let managed = ManagedFeedImage(context: context)
                    managed.id = local.id
                    managed.imageDescription = local.description
                    managed.location = local.location
                    managed.url = local.url
                    return managed
                })
                
                try context.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        let context = self.context
        context.perform {
            do {
                let request = NSFetchRequest<ManagedCache>(entityName: ManagedCache.entity().name!)
                request.returnsObjectsAsFaults = false
                if let cache = try context.fetch(request).first {
                    completion(.found(
                        feed: (cache.feed?
                            .compactMap { ($0 as? ManagedFeedImage) }
                            .compactMap {
                                if let id = $0.id, let url = $0.url {
                                    return LocalFeedImage(id: id, description: $0.imageDescription, location: $0.location, url: url)
                                }
                                return nil
                            }) ?? [],
                        timestamp: cache.timestamp!)
                    )
                } else {
                    completion(.empty)
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
}

private extension NSPersistentContainer {
    enum LoadingError: Swift.Error {
        case modelNotFound
        case failedToLoadPersistentStores(Swift.Error)
    }

    static func load(modelName name: String, in bundle: Bundle, url: URL) throws -> NSPersistentContainer {
        guard let model = NSManagedObjectModel.with(name: name, in: bundle) else {
            throw LoadingError.modelNotFound
        }

        let container = NSPersistentContainer(name: name, managedObjectModel: model)
        container.persistentStoreDescriptions = [.init(url: url)]
        var loadError: Swift.Error?
        container.loadPersistentStores { loadError = $1 }
        try loadError.map { throw LoadingError.failedToLoadPersistentStores($0) }

        return container
    }
}

private extension NSManagedObjectModel {
    static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
        return bundle
            .url(forResource: name, withExtension: "momd")
            .flatMap { NSManagedObjectModel(contentsOf: $0) }
    }
}
