//
//  Playlist.swift
//  FeedTableViewController
//
//  Created by Amitai Blickstein on 6/26/22.
//

import Foundation
import UIKit

private let showPortraitVideos = true

struct Playlist {
    
    /// The "BPA Manual" playlist, id: [d7sk9orq](https://cdn.jwplayer.com/v2/playlists/d7sk9orq)
    static var bpaManual: [PlayerItemModel] = {
        // Simple array of structs from the pairs of titles/sources
        let titles =  showPortraitVideos ? portraitTitles  : landscapeTitles
        let sources = showPortraitVideos ? portraitSources : landscapeSources
        
        return zip(titles, sources)
            .map { PlayerItemModel(
                title: $0,
                source: URL(string: $1)!)
            }
    }()
    
    // MARK: Landscape videos
    private static let landscapeTitles = [
//        "Two Girls Having Fun In A Retro Restaurant",
//        "Computer Fan With Neon Lights",
//        "Little Girl Dressed As An Astronaut Jumping On The Bed",
//        "Lens Focus In Motion",
//        "Competitive Woman Playing Together With Other Gamers",

        "BPA Manual Playlist",
        "Big Buck Bunny 33s",
        "Office chair race",
        "Sunbeam flare shining through colorful clouds",
        "Office super hero delivering high fives",
        "Aerial shot sport car",
        "Young boy practicing kung fu",
        "Happy boy and dog runnings through summer wheat field",
        "Magical forest morning",
        "Happy actors in the park",
        "190915 B 01 Timelapse Danang 05",
        "Sintel - 52sec",
    ]
    
    private static let landscapeSources = [
//       "https://cdn.jwplayer.com/manifests/90gsMZTi.m3u8",
//       "https://cdn.jwplayer.com/manifests/gUG7L7wS.m3u8",
//       "https://cdn.jwplayer.com/manifests/I03KukI9.m3u8",
//       "https://cdn.jwplayer.com/manifests/pCoOm1XY.m3u8",
//       "https://cdn.jwplayer.com/manifests/SPAgxFxi.m3u8",

        "https://cdn.jwplayer.com/manifests/YuJG5ygn.m3u8",
        "https://cdn.jwplayer.com/manifests/XKvnATBz.m3u8",
        "https://cdn.jwplayer.com/manifests/FCEcttZF.m3u8",
        "https://cdn.jwplayer.com/manifests/M2U5cjk2.m3u8",
        "https://cdn.jwplayer.com/manifests/Yj1Me5ji.m3u8",
        "https://cdn.jwplayer.com/manifests/N7thLVIE.m3u8",
        "https://cdn.jwplayer.com/manifests/SgKzo48g.m3u8",
        "https://cdn.jwplayer.com/manifests/A95GxtFI.m3u8",
        "https://cdn.jwplayer.com/manifests/lNjekeid.m3u8",
        "https://cdn.jwplayer.com/manifests/KLwWokqk.m3u8",
        "https://cdn.jwplayer.com/manifests/hysZAKhf.m3u8",
    ]

    
    // MARK: Portrait videos
    static let portraitTitles = [
        "Two Girls Having Fun In A Retro Restaurant",
        "Computer Fan With Neon Lights",
        "Little Girl Dressed As An Astronaut Jumping On The Bed",
        "Lens Focus In Motion",
        "Competitive Woman Playing Together With Other Gamers",
    ]
    
    static let portraitSources = [
        "https://cdn.jwplayer.com/manifests/90gsMZTi.m3u8",
        "https://cdn.jwplayer.com/manifests/gUG7L7wS.m3u8",
        "https://cdn.jwplayer.com/manifests/I03KukI9.m3u8",
        "https://cdn.jwplayer.com/manifests/pCoOm1XY.m3u8",
        "https://cdn.jwplayer.com/manifests/SPAgxFxi.m3u8",
    ]
}

struct PlayerItemModel {
    var title: String
    var source: URL    
}
