//
//  FeedItemModel.swift
//  FeedTableViewControllerV4
//
//  Created by Amitai Blickstein on 5/2/22.
//

import Foundation
import JWPlayerKit

struct FeedItemModel: Decodable {
    var title: String
    var url: String
    var thumbnail: String
    
    func asPlayerItem() -> JWPlayerItem? {
        guard
            let url = URL(string: url),
            let thumbUrl = URL(string: thumbnail)
        else { return nil }
        
        return try? JWPlayerItemBuilder()
            .title(title)
            .file(url)
            .posterImage(thumbUrl)
            .build()
    }
}
