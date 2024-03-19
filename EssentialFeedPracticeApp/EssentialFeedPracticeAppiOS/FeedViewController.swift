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
    private var imageLoadTasks = [IndexPath : FeedImageDataLoaderTask]()
    private var viewAppeared = false
    private var tableModel = [FeedImage]() {
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
            self?.tableModel = feed
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
        let model = tableModel[indexPath.row]
        let cell = FeedImageCell()
        cell.locationContainer.isHidden = model.location == nil
        cell.descriptionLabel.text = model.description
        cell.locationLabel.text = model.location
        cell.feedImageView.image = nil
        cell.retryButton.isHidden = true
        cell.feedImageContainer.startShimmering()
        let loadImage = { [weak self, weak cell] in
            guard let self = self else { return }
            
            self.imageLoadTasks[indexPath] = self.imageLoader?.loadImageData(from: model.url) { [weak cell] result in
                let data = try? result.get()
                let image = data.map(UIImage.init) ?? nil
                cell?.feedImageView.image = image
                cell?.retryButton.isHidden = (image != nil)
                cell?.feedImageContainer.stopShimmering()
            }
        }
        cell.onRetry = loadImage
        loadImage()
        
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelTask(forRowAt: indexPath)
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let cellModel = tableModel[indexPath.row]
            imageLoadTasks[indexPath] = imageLoader?.loadImageData(from: cellModel.url) { _ in }
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelTask)
    }
    
    private func cancelTask(forRowAt indexPath: IndexPath) {
        imageLoadTasks[indexPath]?.cancel()
        imageLoadTasks[indexPath] = nil
    }
}
