//
//  FeedViewModel.swift
//  FeedTableViewControllerV4
//
//  Created by Amitai Blickstein on 5/2/22.
//

import Foundation
import JWPlayerKit

/// All hard-coded and dynamic values required by the table view.
final class FeedViewModel {
    init(with initialItems: [PlayerItemModel]? = nil) {
        self.feedItems = initialItems ?? Playlist.bpaManual
    }
    
    
    // MARK: Private
    
    /// The fetched JSON or JSON-mapped data structures representing video assets from the feed.
    /// Currently mocked with a hard-coded 'feed' of assets.
    private let feedItems: [PlayerItemModel]
    /// The source for the datasource.
    /// - note: The video feed gets 'fed' to (added) here for 'consumption' by (insertion to) the table view.
    private var items = [JWPlayerItem]()
    
    
    // MARK: Public
    
    /// The number of `JWPlayerItem`s currently in the feed/model.
    var count: Int { items.count }

    // Constant values
    let cellReuseIdentifier = PlayerItemCell.reuseIdentifier
    let cellNibName         = PlayerItemCell.reuseIdentifier
    
    /// Returns a `JWPlayerItem` representing the video model (title and URL source) in the data source.
    func itemForVideoMetadata(at index: Int) -> JWPlayerItem {
        // The (relatively simple) implementation is hidden from the table view consuming it.
        items[index]
    }
    
    /// Adds items to the view model, and thus, to the data source.
    ///
    /// Can be called repeatedly to add another copy of the playlist to the feed.
    /// - note: Call when or just before the table view reaches the end of the table in order to
    /// implement an "infinite scrolling feed".
    func insertItems() {
        items += feedItems
            .compactMap { $0.toJWPlayerItem() }
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
