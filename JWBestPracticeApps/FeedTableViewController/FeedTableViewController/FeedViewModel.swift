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
    
    private let client = MockJWClient()
    
    private var items       = [JWPlayerItem]()
    private var currentPage = 1 // increments until all items are loaded
    private var total       = 0
    private var isFetchInProgress = false
    
    var totalCount:   Int { total }
    var currentCount: Int { items.count }
    
    init(delegate: FeedViewModelDelegate) {
        self.delegate = delegate
    }
    
    func item(at index: Int) -> JWPlayerItem {
        items[index]
    }
    
    @MainActor
    /// Can be called repeatedly until all pages are loaded.
    func fetchItems() {
        guard !isFetchInProgress
        else { return }
        
        isFetchInProgress = true
        
        // 'fetch' here, get [newItems]
        client.fetchMediaItemsFromMockFeed(forPage: currentPage) { [self] result in
            switch result {
                case .failure(let error):
                    isFetchInProgress = false
                    delegate?.onFetchFailed(with: error.localizedDescription)
                case .success(let response):
                    // success
                    currentPage += 1
                    isFetchInProgress = false
        
                    total = response.total
                    
                    let fetchedItems = response.mediaItems.compactMap { $0.asPlayerItem() }
                    items.append(contentsOf: fetchedItems)
                    
                    if response.page > 1 {
                        let indexPathsToReload = indexPathsToReload(from: fetchedItems)
                        delegate?.onFetchCompleted(with: indexPathsToReload)
                    } else {
                        delegate?.onFetchCompleted(with: .none)
                    }
            }
        }
    }
    
    private func indexPathsToReload(from newItems: [JWPlayerItem]) -> [IndexPath] {
        let startIndex = items.count - newItems.count
        let endIndex   = startIndex  + newItems.count
        return (startIndex..<endIndex)
            .map { IndexPath(row: $0, section: 0) }
    }
}
