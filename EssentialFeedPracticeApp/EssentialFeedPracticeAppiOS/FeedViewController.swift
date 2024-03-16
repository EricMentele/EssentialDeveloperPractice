//
//  FeedViewController.swift
//  EssentialFeedPracticeApp
//
//  Created by Eric Mentele on 3/15/24.
//

import UIKit
import EssentialFeedPracticeApp

public final class FeedViewController: UITableViewController {
    private var loader: FeedLoader?
    private var viewAppeared = false
    private var tableModel: [FeedImage] = []
    
    public convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        load()
    }
    
    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        startRefreshIfViewHasNotAppearedBefore()
    }
    
    @objc private func load() {
        refreshControl?.beginRefreshing()
        loader?.load { [weak self] result in
            self?.tableModel = (try? result.get()) ?? []
            self?.tableView.reloadData()
            self?.refreshControl?.endRefreshing()
        }
    }
    
    @objc func startRefreshIfViewHasNotAppearedBefore() {
        if !viewAppeared {
            refreshControl?.beginRefreshing()
            viewAppeared = true
        }
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = tableModel[indexPath.row]
        let cell = FeedImageCell()
        cell.locationContainer.isHidden = model.location == nil
        cell.descriptionLabel.text = model.description
        cell.locationLabel.text = model.location
        return cell
    }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
}
