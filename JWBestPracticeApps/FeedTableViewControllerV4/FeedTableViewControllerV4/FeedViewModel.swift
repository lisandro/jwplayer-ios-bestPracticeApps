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
    func onFetchFailed(with reason: String)
}

final class FeedViewModel {
    private weak var delegate: FeedViewModelDelegate?
    
    private var items       = [JWPlayerItem]()
    private var total       = 0
    var totalCount:   Int { total }
    var currentCount: Int { items.count }
    
    init(delegate: FeedViewModelDelegate) {
        self.delegate = delegate
    }
    
    func item(at index: Int) -> JWPlayerItem {
        items[index]
    }
    
    func fetchItems() {
        // 'fetch' here, get [newItems]
        let fetchedItems = fetchFeed()
        
        // success
        total += fetchedItems.count // new total
        items.append(contentsOf: fetchedItems)
        
        let indexPathsToReload = indexPathsToReload(from: fetchedItems)
        delegate?.onFetchCompleted(with: indexPathsToReload)
    }
    
    private func indexPathsToReload(from newItems: [JWPlayerItem]) -> [IndexPath] {
        let startIndex = items.count - newItems.count
        let endIndex   = startIndex  + newItems.count
        return (startIndex..<endIndex)
            .map { IndexPath(row: $0, section: 0) }
    }
    
    // Currently, feed of player items is "fetched" from a local plist.
    private func fetchFeed() -> [JWPlayerItem] {
        guard
            let feedURL = Bundle.main.url(forResource: "Feed", withExtension: "plist"),
            let feedData = try? Data(contentsOf: feedURL),
            let mockFeed = try? PropertyListDecoder().decode(FeedItemList.self, from: feedData)
        else { return [] }

        return mockFeed.compactMap { $0.asPlayerItem() }
    }
}
