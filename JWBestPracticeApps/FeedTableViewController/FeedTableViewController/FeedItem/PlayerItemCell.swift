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
            
    // Provided by viewModel.
    var item: JWPlayerItem? {
        didSet { configureCellPlayer(with: item) }
    }
    
    // The view (UIView subclass) underlying this View (in the MVVM sense)
    @IBOutlet weak var playerView: JWPlayerView!
    // To show the video #, that the feed is "infinite"
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    private func configureCellPlayer(with item: JWPlayerItem?) {
        guard let itemConfig = getPlayerConfig(for: item)
        else { return }

        titleLabel.text = item?.title
        playerView.player.configurePlayer(with: itemConfig)
        playerView.videoGravity = .resizeAspectFill
    }
    
    private func getPlayerConfig(for item: JWPlayerItem?) -> JWPlayerConfiguration? {
        guard let item = item
        else { return nil }

        do {
            return try JWPlayerConfigurationBuilder()
                .playlist([item])
                .autostart(true)
                .repeatContent(true)
                .build()
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
