//
//  FeedItemCell.swift
//  FeedTableViewController
//
//  Created by David Almaguer on 8/14/19.
//  Copyright © 2019 Karim Mourra. All rights reserved.
//

import UIKit
import JWPlayerKit

let FeedItemCellDefaultHeight: CGFloat = 300
let FeedItemCellIdentifier: String = "FeedItemCell"

class FeedItemCell: UITableViewCell {
    @IBOutlet weak var playerView: JWPlayerView!
    
    var item: JWPlayerItem? {
        didSet {
            configureCellPlayer(with: item)
        }
    }
    
    private func configureCellPlayer(with item: JWPlayerItem?) {
        guard let item = item,
              let itemConfig = getPlayerConfig(for: item)
        else {
            return
        }

        self.playerView.player.configurePlayer(with: itemConfig)
    }
    
    private func getPlayerConfig(for item: JWPlayerItem) -> JWPlayerConfiguration? {
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
    
    override var reuseIdentifier: String? {
        return FeedItemCellIdentifier
    }
}
