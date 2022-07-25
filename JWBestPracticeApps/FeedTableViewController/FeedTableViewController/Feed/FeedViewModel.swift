//
//  FeedViewModel.swift
//  FeedTableViewControllerV4
//
//  Created by Amitai Blickstein on 5/2/22.
//

import Foundation
import JWPlayerKit

protocol FeedViewModelDelegate: AnyObject {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
}

final class FeedViewModel {
    private weak var delegate: FeedViewModelDelegate?

    // Dynamic values
    private var items       = [JWPlayerItem]()
    private var total: Int?
    
    // Derived values
    var totalCount:       Int { total ?? currentCount }
    var currentCount:     Int { items.count }
    var numberOfSections: Int { (totalCount > 0) ? 1 : 0 }

    // Constant values
    var cellDefaultHeight: CGFloat { 300 }
    var cellReuseIdentifier = PlayerItemCell.reuseIdentifier
    var cellNibName         = PlayerItemCell.reuseIdentifier
    
    // Hard-coded demo response.
    let feedPrototype: JWV2Playlist
    
    init(delegate: FeedViewModelDelegate) {
        self.delegate = delegate
        feedPrototype = JWV2Playlist.exampleManualPlaylist
    }
    
    func item(at index: Int) -> JWPlayerItem {
        items[index]
    }
    
    @MainActor
    /// Can be called repeatedly until all pages are loaded.
    func addBatchedItems() {
        let itemsToAdd = feedPrototype
            .playlist?
            .compactMap({
                FeedItemModel
                    .from(playlistItem: $0)?
                    .toJWPlayerItem()
            })
        ?? []
        
        items += itemsToAdd
        let indexPathsToReload = indexPathsToReload(from: itemsToAdd)
        delegate?.onFetchCompleted(with: indexPathsToReload)
    }
    
    private func indexPathsToReload(from newItems: [JWPlayerItem]) -> [IndexPath] {
        let startIndex    = items.count - newItems.count
        let endIndex      = startIndex  + newItems.count
        let pathsToReload = (startIndex..<endIndex)
            .map { IndexPath(row: $0, section: 0) }
//        print(pathsToReload)
        return pathsToReload
    }
}
