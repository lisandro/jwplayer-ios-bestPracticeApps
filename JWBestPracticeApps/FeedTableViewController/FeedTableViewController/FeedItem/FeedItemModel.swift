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
    var videoUrl: String
    var thumbnailUrl: String
    
    func asPlayerItem() -> JWPlayerItem? {
        guard
            let videoURL = URL(string: videoUrl),
            let thumbnailURL = URL(string: thumbnailUrl)
        else { return nil }
        
        return try? JWPlayerItemBuilder()
            .title(title)
            .file(videoURL)
            .posterImage(thumbnailURL)
            .build()
    }
}
