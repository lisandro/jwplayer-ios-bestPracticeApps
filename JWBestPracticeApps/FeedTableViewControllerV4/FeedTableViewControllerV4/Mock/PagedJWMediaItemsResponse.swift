//
//  PagedJWMediaItemsResponse.swift
//  FeedTableViewControllerV4
//
//  Created by Amitai Blickstein on 5/3/22.
//

import Foundation

/// Built as a MOCK response only!
struct PagedJWMediaItemsResponse {
    let mediaItems: [FeedItemModel]
    let total: Int
    let page_length: Int
    let page: Int
}
