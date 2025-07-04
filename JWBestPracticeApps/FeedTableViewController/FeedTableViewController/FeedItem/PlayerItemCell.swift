//
//  PlayerItemCell.swift
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

    /// Starts player's playback by configuring or loading the item.
    public func startPlayback() {
        guard let item,
              let config = getPlayerConfig(for: item) else {
            return
        }

        if playerNeedsToBeConfigured() {
            playerView.player.configurePlayer(with: config)
        } else {
            playerView.player.loadPlaylist(items: [item])
        }
    }

    /// Pauses player's playback
    public func pausePlayback() {
        playerView.player.pause()
    }

    /// Loads the cell's player using the relatively inexpensive `loadPlaylist` API.
    private func loadCellPlayer(with item: JWPlayerItem?) {
        titleLabel.text = item?.title
        playerView.videoGravity = .resizeAspectFill
    }
    
    /// If the player has not been initialized yet, or is stuck in an unrecoverable error state,
    /// then `configure` is needed. Otherwise, calling `loadPlaylist` is the performant way to play
    /// a new asset without expensive player creation.
    /// - Returns: Returns `true` if the player is in the `error` or `unknown` states.
    private func playerNeedsToBeConfigured() -> Bool {
        [.unknown, .error]
            .contains(playerView.player.getState())
    }
    
    private func getPlayerConfig(for item: JWPlayerItem?) -> JWPlayerConfiguration? {
        guard let item else {
            return nil
        }

        return try? JWPlayerConfigurationBuilder()
            .playlist(items: [item])
            .autostart(true)
            .preload(.auto)
            .repeatContent(true)
            .build()
    }

    func setPlayerView(_ view: JWPlayerView) {
        // Remove any existing JWPlayerView subviews
        removePlayerView()
        view.frame = playerView.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        playerView.addSubview(view)
    }

    func removePlayerView() {
        for subview in playerView.subviews {
            if subview is JWPlayerView {
                subview.removeFromSuperview()
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        removePlayerView()
    }
}
