//
//  FeedTableViewController.swift
//  FeedTableViewController
//
//  Created by David Almaguer on 8/14/19.
//  Copyright © 2019 Karim Mourra. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController {
    private var viewModel = FeedViewModel.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.addMoreItems()
        
        // Register the custom cell view
        let feedNib = UINib(nibName: viewModel.cellNibName, bundle: .main)
        tableView.register(feedNib, forCellReuseIdentifier: viewModel.cellReuseIdentifier)
        tableView.isPagingEnabled = true
    }

    // MARK: UITableViewDelegate implementation
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? PlayerItemCell
        else { return }
        
        cell.playerView.player.pause()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // TODO: When you hit the bottom, expand the table
    }
    
    // MARK: - UITableViewDataSource implementation
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.height
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.cellReuseIdentifier, for: indexPath) as? PlayerItemCell
        else { return UITableViewCell() }
        
        cell.item = viewModel.item(at: indexPath.row)
        cell.descriptionLabel.text = "video #\(indexPath.row + 1)"
        
        return cell
    }

    /// Calculates the rows that need to be reloaded
    /// - Parameter indexPaths: Previously calculated by the view model.
    /// - Returns: The paths that are both in the view model AND are visible.
    private func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}

extension UIView {
    var width:  CGFloat { frame.size.width  }
    var height: CGFloat { frame.size.height }
    var left:   CGFloat { frame.origin.x    }
    var right:  CGFloat { left + width      }
    var top:    CGFloat { frame.origin.y    }
    var bottom: CGFloat { top + height      }
}
