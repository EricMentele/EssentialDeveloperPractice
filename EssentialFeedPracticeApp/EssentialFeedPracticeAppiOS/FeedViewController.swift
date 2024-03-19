//
//  FeedViewController.swift
//  EssentialFeedPracticeApp
//
//  Created by Eric Mentele on 3/15/24.
//

import UIKit
import EssentialFeedPracticeApp

public final class FeedViewController: UITableViewController, UITableViewDataSourcePrefetching {
    public var feedRefreshController: FeedRefreshViewController?
    
    private var imageLoader: FeedImageDataLoader?
    private var viewAppeared = false
    private var tableModel = [FeedImageCellController]() {
        didSet { tableView.reloadData() }
    }
    
    public convenience init(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) {
        self.init()
        self.feedRefreshController = FeedRefreshViewController(feedLoader: feedLoader)
        self.imageLoader = imageLoader
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        feedRefreshController?.onRefresh = { [weak self] feed in
            self?.tableModel = feed.map { FeedImageCellController(model: $0, imageLoader: self!.imageLoader!) }
        }
        refreshControl = feedRefreshController?.view
        tableView.prefetchDataSource = self
    }
    
    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        startRefreshIfViewHasNotAppearedBefore()
    }
    
    @objc func startRefreshIfViewHasNotAppearedBefore() {
        if !viewAppeared {
            feedRefreshController?.refresh()
            viewAppeared = true
        }
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellController(forRowAt: indexPath).view()
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellController(forRowAt: indexPath).cancelLoad()
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { cellController(forRowAt: $0).preload() }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { cellController(forRowAt: $0).cancelLoad() }
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> FeedImageCellController {
        return tableModel[indexPath.row]
    }
}
