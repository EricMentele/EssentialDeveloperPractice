//
//  FeedViewController+TestHelpers.swift
//  EssentialFeedPracticeAppiOSTests
//
//  Created by Eric Mentele on 3/18/24.
//

import EssentialFeedPracticeAppiOS
import UIKit

class FakeRefreshControl: UIRefreshControl {
    private var _isRefreshing = false
    
    override var isRefreshing: Bool {
        _isRefreshing
    }
    
    override func beginRefreshing() {
        _isRefreshing = true
    }
    
    override func endRefreshing() {
        _isRefreshing = false
    }
}

extension FeedViewController {
    var isShowingLoadingIndicator: Bool {
        refreshControl?.isRefreshing == true
    }
    var feedImagesSection: Int { 0 }
    var numberOfRenderedFeedImageViews: Int { tableView.numberOfRows(inSection: feedImagesSection) }
    
    func feedImageView(at row: Int) -> UITableViewCell? {
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: feedImagesSection)
        return ds?.tableView(tableView, cellForRowAt: index)
    }
    
    func fakeRefreshControlForiOS17Support() {
        feedRefreshController?.fakeRefreshControlForiOS17Support()
        refreshControl = feedRefreshController?.view
    }
    
    func fullyLoadViewLifecycleWithMockedRefreshController() {
        loadViewIfNeeded()
        fakeRefreshControlForiOS17Support()
        runViewIsAppearing()
    }
    
    private func runViewIsAppearing() {
        beginAppearanceTransition(true, animated: false)
        endAppearanceTransition()
    }
    
    func simulateUserInitiatedFeedReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    @discardableResult
    func simulateFeedImageViewVisible(at index: Int) -> FeedImageCell? {
        return feedImageView(at: index) as? FeedImageCell
    }
    
    func simulateFeedImageViewNotVisible(at row: Int) {
        let view = simulateFeedImageViewVisible(at: row)
        
        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: feedImagesSection)
        delegate?.tableView?(tableView, didEndDisplaying: view!, forRowAt: index)
    }
    
    func simulateFeedImageViewNearVisible(at row: Int) {
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: feedImagesSection)
        ds?.tableView(tableView, prefetchRowsAt: [index])
    }
    
    func simulateFeedImageViewNotNearVisible(at row: Int) {
        simulateFeedImageViewNearVisible(at: row)
        
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: feedImagesSection)
        ds?.tableView?(tableView, cancelPrefetchingForRowsAt: [index])
    }
}
