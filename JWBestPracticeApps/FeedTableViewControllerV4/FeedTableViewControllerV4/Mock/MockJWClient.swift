//
//  MockFeed.swift
//  FeedTableViewControllerV4
//
//  Created by Amitai Blickstein on 5/3/22.
//

import Foundation
import JWPlayerKit

class MockJWClient {
    // Currently, feed of player items is "fetched" from a local plist.
    func fetchMediaItemsFromMockFeed(forPage page: Int, completion: @escaping (Result<PagedJWMediaItemsResponse, MockError>)-> Void) {

        let response = MockResponse(page: page)
        let pagedResponse = PagedJWMediaItemsResponse(
            mediaItems: response.itemList,
            total: response.total,
            page_length: response.pageLength,
            page: response.page
        )
        completion(.success(pagedResponse))
        
        if false {
            completion(.failure(MockError.willNeverBeThrown))
        }
    }
}

fileprivate struct MockResponse {
    let total = 100
    let pageLength = 7
    var pages: Int {
        Int(ceil(Double(total) / Double(pageLength))) // 15
    }
    let page: Int

    ///
    /// - Parameter page: The current page of the response.
    init(page: Int = 1) {
        self.page = page
    }
    
    // Currently, feed of player items is "fetched" from a local plist.
    var itemList: [FeedItemModel] = {
        guard
            let feedURL = Bundle.main.url(forResource: "Feed", withExtension: "plist"),
            let feedData = try? Data(contentsOf: feedURL),
            let mockFeed = try? PropertyListDecoder().decode([FeedItemModel].self, from: feedData)
        else { return [] }
        
        return mockFeed
    }()
}

enum MockError: Error {
    case willNeverBeThrown
}
