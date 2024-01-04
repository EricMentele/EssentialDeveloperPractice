//
//  RemoteFeedLoader.swift
//  EssentialFeedPracticeApp
//
//  Created by Eric Mentele on 12/18/23.
//

import Foundation

public final class RemoteFeedLoader: FeedLoader {
    private let client: HTTPClient
    private let url: URL
    
    public typealias Result = LoadFeedResult<Error>
    
    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case let .success(data, response):
                switch response.statusCode {
                case 200:
                    do {
                        let items = try FeedItemsMapper.map(data)
                        completion(.success(items))
                    } catch {
                        completion(.failure(.invalidData))
                    }
                default:
                    completion(.failure(.invalidData))
                }
            case .failure:
                completion(.failure(.connectivity))
            
            }
        }
    }
}

// MARK: - Associated Types

extension RemoteFeedLoader {
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
}
