//
//  FeedTableViewController.swift
//  FeedTableViewController
//
//  Created by Amitai Blickstein on 6/26/22.
//

import UIKit

class FeedTableViewController: UITableViewController {
    private var viewModel = FeedViewModel(with: Playlist.bpaManual)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Must be called once to populate the table view.
        viewModel.insertItems()
        
        // Register the custom cell view
        let feedNib = UINib(nibName: viewModel.cellNibName, bundle: .main)
        tableView.register(feedNib, forCellReuseIdentifier: viewModel.cellReuseIdentifier)
        tableView.isPagingEnabled = true
        tableView.rowHeight = view.bounds.inset(by: view.safeAreaInsets).height
    }

    // MARK: UITableViewDelegate implementation
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? PlayerItemCell
        else { return }
        
        // Pause a cell as it goes offscreen
        cell.playerView.player.pause()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? PlayerItemCell
        else { return }
        
        // Play a cell as it becomes visible
        cell.playerView.player.play()

        // Add more rows when we hit the end.
        if indexPath.row == viewModel.count - 1 {
            viewModel.insertItems()
            tableView.reloadData()
            // 👆 TODO: For performance and resource-efficiency, consider replacing 'reloadData()' with `reloadRows(at:with:)` for the (new && visible) rows.
        }
    }
    
    // MARK: - UITableViewDataSource implementation
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.cellReuseIdentifier, for: indexPath) as? PlayerItemCell
        else { return UITableViewCell() }
        
        cell.item = viewModel.itemForVideoMetadata(at: indexPath.row)
        cell.descriptionLabel.text = "video #\(indexPath.row + 1)"
        
        return cell
    }
}
