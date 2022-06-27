//
//  FeedItemModel.swift
//  FeedTableViewControllerV4
//
//  Created by Amitai Blickstein on 5/2/22.
//

import Foundation
import JWPlayerKit
import UniformTypeIdentifiers

struct FeedItemModel: Decodable {
    var title: String
    var videoUrl: String
    var thumbnailUrl: String
    
    static func from(playlistItem: PlaylistItem) -> Self? {
        guard
            let title    = playlistItem.title,
            let source   = playlistItem.sources?.first(where: { $0.file?.isHls ?? false }),
            let videoUrl = source.file,
            let imageUrl = playlistItem.image
        else { return nil }
        
        return FeedItemModel(
            title: title,
            videoUrl: videoUrl.absoluteString,
            thumbnailUrl: imageUrl.absoluteString
        )
    }
    
    func toJWPlayerItem() -> JWPlayerItem? {
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

extension URL {
    fileprivate var isHls: Bool? {
        guard let fileExtSubstring = absoluteString.split(separator: ".").last
        else { return nil }
        
        let ext = String(fileExtSubstring)
        
        guard let type = UTTypeReference(filenameExtension: ext)
        else { return nil }
        
        return type.preferredFilenameExtension?.contains("m3u")
    }
}
