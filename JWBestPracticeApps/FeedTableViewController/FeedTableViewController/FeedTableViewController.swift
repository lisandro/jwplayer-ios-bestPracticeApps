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
        let feedNib = UINib(nibName: viewModel.cellNibName, bundle: Bundle.main)
        tableView.register(feedNib, forCellReuseIdentifier: viewModel.cellReuseIdentifier)
        let loadingNib = UINib(nibName: "LoadingCell", bundle: nil)
        tableView.register(loadingNib, forCellReuseIdentifier: LoadingCell.reuseIdentifer)
    }

    // MARK: UITableViewDelegate implementation
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? FeedItemCell
        else { return }
        
        cell.playerView.player.pause()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.currentCount - 5 {
            viewModel.addBatchedItems()
        }
    }
    
    // MARK: UITableViewDataSource implementation
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections + 1 // for the loading cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let isVideoSection    = section == 0
        let isLoadingSection  = section == tableView.numberOfSections - 1
        
        if isVideoSection {
            return viewModel.totalCount
        }
        
        if isLoadingSection {
            return 1
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.cellDefaultHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isVideoSection    = indexPath.section == 0
        let isLoadingSection  = indexPath.section == tableView.numberOfSections - 1
        
        if isVideoSection {
            let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.cellReuseIdentifier, for: indexPath)
            
            guard let cell = cell as? FeedItemCell
            else { return UITableViewCell() }
            
            cell.item = viewModel.item(at: indexPath.row)
            
            return cell
        } else if isLoadingSection {
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadingCell.reuseIdentifer, for: indexPath)
            
            guard let cell = cell as? LoadingCell
            else { return UITableViewCell() }
            
            cell.activityIndicator.startAnimating()
            return cell
        }
        
        return UITableViewCell()
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
