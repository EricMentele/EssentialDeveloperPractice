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
    
    public lazy var view = binded(UIRefreshControl())
    private let viewModel: FeedViewModel

    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
    }
    
    @objc public func refresh() {
        viewModel.loadFeed()
    }
    
    public func binded(_ view: UIRefreshControl) -> UIRefreshControl {
        viewModel.onLoadingStateChange = { [weak view] isLoading in
            if isLoading {
                view?.beginRefreshing()
            } else {
                view?.endRefreshing()
            }
        }
        
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
