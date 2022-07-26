//
//  FeedViewModel.swift
//  FeedTableViewControllerV4
//
//  Created by Amitai Blickstein on 5/2/22.
//

import Foundation
import JWPlayerKit

/// All hard-coded and dynamic values required by the table view.
/// Since there is only one d-source for a table view, this is a singleton.
final class FeedViewModel {
    // Singleton pattern
    static let shared = FeedViewModel()
    private init() {}
    
    // Dynamic values
    private var items = [JWPlayerItem]()
    
    // Derived values
    var count: Int { items.count }

    // Constant values
    var cellReuseIdentifier = PlayerItemCell.reuseIdentifier
    var cellNibName         = PlayerItemCell.reuseIdentifier
    
    func item(at index: Int) -> JWPlayerItem {
        items[index]
    }
    
    /// Can be called repeatedly to add another copy of the playlist to the feed.
    func addMoreItems() {
        let itemsToAdd = Playlist.bpaManual
            .compactMap {
                try? JWPlayerItemBuilder()
                    .title($0.title)
                    .file($0.source)
                    .build()
            }
        
        items += itemsToAdd
        // Here's a good place to calculate the index paths of just the new rows, to reload.
    }
}

fileprivate extension PlayerItemModel {
    func toJWPlayerItem() -> JWPlayerItem? {
        try? JWPlayerItemBuilder()
            .title(title)
            .file(source)
            .build()
    }
}
