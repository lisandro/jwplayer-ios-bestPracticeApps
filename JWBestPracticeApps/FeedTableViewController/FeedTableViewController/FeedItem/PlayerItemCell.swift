//
//  FeedItemCell.swift
//  FeedTableViewController
//
//  Created by Amitai Blickstein on 6/26/22.
//

import UIKit
import JWPlayerKit

class PlayerItemCell: UITableViewCell {
    static let reuseIdentifier = "PlayerItemCell"
    static let nibName         = "PlayerItemCell"
            
    /// The view (UIView subclass) underlying this View (in the MVVM sense)
    @IBOutlet weak var playerView: JWPlayerView!
    /// Shows the video # in the array, to make it clear that the feed is "infinite".
    @IBOutlet weak var descriptionLabel: UILabel!
    /// The video title. Obtained from your video provider solution.
    @IBOutlet weak var titleLabel: UILabel!

    /// Provided by viewModel.
    /// - note: Loads the cell's player with the new item when assigned.
    var item: JWPlayerItem? {
        willSet { loadCellPlayer(with: newValue) }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Expensive player initialization via the `configurePlayer(with:)` API should be kept to a minimum.
        let oneBlackScreen = Playlist.oneBlackScreen[0]
        playerView.player.configurePlayer(with: getPlayerConfig(for: oneBlackScreen)!)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playerView.player.stop()
    }
    
    /// Loads the cell's player using the relatively inexpensive `loadPlaylist` API.
    private func loadCellPlayer(with item: JWPlayerItem?) {
        guard let item = item
        else { return }

        titleLabel.text = item.title
        playerView.player.loadPlaylist([item])
        playerView.videoGravity = .resizeAspectFill
    }
    
    private func getPlayerConfig(for item: JWPlayerItem?) -> JWPlayerConfiguration? {
        guard let item = item
        else { return nil }

        return try? JWPlayerConfigurationBuilder()
            .playlist([item])
            .autostart(true)
            .repeatContent(true)
            .build()
    }
}
