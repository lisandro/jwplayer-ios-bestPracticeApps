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
    var cellDefaultHeight: CGFloat { 300 }
    var cellReuseIdentifier = PlayerItemCell.reuseIdentifier
    var cellNibName         = PlayerItemCell.reuseIdentifier
    
    func item(at index: Int) -> JWPlayerItem {
        items[index]
    }
    
    @MainActor
    /// Can be called repeatedly until all pages are loaded.
    func addMoreItems() {
        let itemsToAdd = Playlist.bpaManual
            .compactMap {
                try? JWPlayerItemBuilder()
                    .title($0.title)
                    .file($0.source)
                    .build()
            }
        
        items += itemsToAdd
//        let indexPathsToReload = indexPathsToReload(from: itemsToAdd)
    }
    
//    private func indexPathsToReload(from newItems: [JWPlayerItem]) -> [IndexPath] {
//        let startIndex    = items.count - newItems.count
//        let endIndex      = startIndex  + newItems.count
//        let pathsToReload = (startIndex..<endIndex)
//            .map { IndexPath(row: $0, section: 0) }
//        return pathsToReload
//    }
}


fileprivate extension PlayerItemModel {
    func toJWPlayerItem() -> JWPlayerItem? {
        try? JWPlayerItemBuilder()
            .title(title)
            .file(source)
            .build()
    }
}
