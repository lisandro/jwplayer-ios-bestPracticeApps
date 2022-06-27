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
        viewModel = FeedViewModel(delegate: self)
        viewModel.addBatchedItems()
        
        // Register the custom cell view
        let nib = UINib(nibName: viewModel.cellNibName, bundle: Bundle.main)
        self.tableView.register(nib, forCellReuseIdentifier: viewModel.cellReuseIdentifier)
    }

    // MARK: UITableViewDelegate implementation
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? FeedItemCell
        else { return }
        
        cell.playerView.player.pause()
    }
    
    // MARK: UITableViewDataSource implementation
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.totalCount
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.cellDefaultHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.cellReuseIdentifier, for: indexPath)
        
        guard let cell = cell as? FeedItemCell
        else { return UITableViewCell() }
        
        cell.item = viewModel.item(at: indexPath.row)
        
        return cell
    }
}

// MARK: UITableViewDataSourcePrefetching implementation
extension FeedTableViewController {


    /// Calculates the rows that need to be reloaded
    /// - Parameter indexPaths: Previously calculated by the view model.
    /// - Returns: The paths that are both in the view model AND are visible.
    private func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}

extension FeedTableViewController: FeedViewModelDelegate {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToReload else { return }
        tableView.reloadRows(at: newIndexPathsToReload, with: .automatic)
    }
}
