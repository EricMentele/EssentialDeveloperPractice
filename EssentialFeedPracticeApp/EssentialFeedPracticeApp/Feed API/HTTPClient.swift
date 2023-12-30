//
//  HTTPClient.swift
//  EssentialFeedPracticeApp
//
//  Created by Eric Mentele on 12/30/23.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}
