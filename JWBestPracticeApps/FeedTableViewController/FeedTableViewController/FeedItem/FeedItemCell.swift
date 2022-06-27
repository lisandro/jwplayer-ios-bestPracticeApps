//
//  FeedItemCell.swift
//  FeedTableViewController
//
//  Created by David Almaguer on 8/14/19.
//  Copyright © 2019 Karim Mourra. All rights reserved.
//

import UIKit
import JWPlayerKit

class FeedItemCell: UITableViewCell {
    // Reuse ID
    static   let reuseIdentifier = "FeedItemCell"
    override var reuseIdentifier: String? { FeedItemCell.reuseIdentifier }
            
    // Provided by viewModel.
    var item: JWPlayerItem? {
        didSet { configureCellPlayer(with: item) }
    }
    
    // The view (UIView subclass) underlying this View (in the MVVM sense)
    @IBOutlet weak var playerView: JWPlayerView!
    
    private func configureCellPlayer(with item: JWPlayerItem?) {
        guard let itemConfig = getPlayerConfig(for: item)
        else { return }

        self.playerView.player.configurePlayer(with: itemConfig)
    }
    
    private func getPlayerConfig(for item: JWPlayerItem?) -> JWPlayerConfiguration? {
        guard let item = item
        else { return nil }

        do {
            return try JWPlayerConfigurationBuilder()
                .playlist([item])
                .autostart(true)
                .build()
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
