//
//  RemoteFeedLoader.swift
//  EssentialFeedPracticeApp
//
//  Created by Eric Mentele on 12/18/23.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public final class RemoteFeedLoader {
    private let client: HTTPClient
    private let url: URL
    
    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case let .success(data, response):
                guard let root = try? JSONDecoder().decode(Root.self, from: data) else {
                    completion(.failure(.invalidData))
                    return
                }
                switch response.statusCode {
                case 200:
                    completion(.success(root.items))
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
    public enum Result: Equatable {
        case success([FeedItem])
        case failure(Error)
    }
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    private struct Root: Decodable {
        let items: [FeedItem]
    }
}
