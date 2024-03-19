//
//  FeedRefreshViewController.swift
//  EssentialFeedPracticeAppiOS
//
//  Created by Eric Mentele on 3/18/24.
//

import UIKit
import EssentialFeedPracticeApp

public final class FeedRefreshViewController: NSObject {
    public var onRefresh: (([FeedImage]) -> Void)?
    
    public lazy var view: UIRefreshControl = {
        let refreshView = UIRefreshControl()
        refreshView.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshView
    }()
    private let feedLoader: FeedLoader

    public init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    @objc public func refresh() {
        view.beginRefreshing()
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.onRefresh?(feed)
            }
            self?.view.endRefreshing()
        }
    }
}
