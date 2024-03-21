//
//  FeedRefreshViewController.swift
//  EssentialFeedPracticeAppiOS
//
//  Created by Eric Mentele on 3/18/24.
//

import UIKit

public final class FeedRefreshViewController: NSObject, FeedLoadingView {
    public lazy var view = loadView()
    private let loadFeed: () -> Void

    public init(loadFeed: @escaping () -> Void) {
        self.loadFeed = loadFeed
    }
    
    @objc func refresh() {
        loadFeed()
    }
    
    func display(_ viewModel: FeedLoadingViewModel) {
        if viewModel.isLoading {
            view.beginRefreshing()
        } else {
            view.endRefreshing()
        }
    }
    
    private func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
