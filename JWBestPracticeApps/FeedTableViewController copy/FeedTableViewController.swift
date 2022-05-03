//
//  FeedTableViewController.swift
//  FeedTableViewController
//
//  Created by David Almaguer on 8/14/19.
//  Copyright © 2019 Karim Mourra. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController {

    private var viewModel: FeedViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register the custom cell view
        let nib = UINib(nibName: FeedItemCellIdentifier, bundle: Bundle.main)
        self.tableView.register(nib, forCellReuseIdentifier: FeedItemCellIdentifier)
        
        viewModel = FeedViewModel(delegate: self)
        viewModel.fetchItems()
    }

    // MARK: UITableViewDelegate implementation
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? FeedItemCell
        else { return }
        
        cell.playerView.player.pause()
    }
    
    // MARK: UITableViewDataSource implementation
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        (viewModel.totalCount > 0) ? 1 : 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.totalCount
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        FeedItemCellDefaultHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedItemCellIdentifier, for: indexPath)
        
        guard let cell = cell as? FeedItemCell
        else { return UITableViewCell() }
        
        cell.item = viewModel.item(at: indexPath.row)
        
        return cell
    }
    
}

extension FeedTableViewController: FeedViewModelDelegate {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
//    TODO: Implement me
        guard let newIndexPathsToReload = newIndexPathsToReload else { return }
        tableView.reloadRows(at: newIndexPathsToReload, with: .automatic)
    }
    
    func onFetchFailed(with reason: String) {
        //    TODO: Implement me
    }
}
