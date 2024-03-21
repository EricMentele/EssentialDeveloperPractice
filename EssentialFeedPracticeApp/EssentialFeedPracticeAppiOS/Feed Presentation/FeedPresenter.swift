//
//  FeedPresenter.swift
//  EssentialFeedPracticeAppiOS
//
//  Created by Eric Mentele on 3/20/24.
//

import EssentialFeedPracticeApp

struct FeedLoadingViewModel {
    var isLoading: Bool
}

protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel)
}

struct FeedViewModel {
    var feed: [FeedImage]
}

protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

public final class FeedPresenter {
    var feedView: FeedView?
    var loadingView: FeedLoadingView?
    
    func didStartLoadingFeed() {
        loadingView?.display(.init(isLoading: true))
    }
    
    func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView?.display(.init(feed: feed))
        loadingView?.display(.init(isLoading: false))
    }
    
    func didFinishLoadingFeed(with error: Error) {
        loadingView?.display(FeedLoadingViewModel(isLoading: false))
    }
}
