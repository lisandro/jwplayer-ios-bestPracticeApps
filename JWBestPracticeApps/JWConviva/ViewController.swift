//
//  ViewController.swift
//  JWConviva
//
//  Created by Kateryna Obertynska on 3/18/19.
//  Copyright © 2019 Karim Mourra. All rights reserved.
//

import UIKit

class ViewController: UIViewController, JWPlayerDelegate {
    
    @IBOutlet weak var playerPlaceholder: UIView!
    
    private let player: JWPlayerController = {
        let jwConfig = JWConfig()
        
        let playlistItem1 = JWPlaylistItem()
        playlistItem1.title = "JW Promo"
        playlistItem1.file = "http://playertest.longtailvideo.com/jwpromo/jwpromo.m3u8"
        
        let playlistItem2 = JWPlaylistItem()
        playlistItem2.title = "Elephants Dream"
        playlistItem2.file = "http://wowzaec2demo.streamlock.net/vod-multitrack/_definst_/smil:ElephantsDream/ElephantsDream.smil/playlist.m3u8"
        
        jwConfig.playlist = [playlistItem1, playlistItem2]
        
        let adConfig = JWAdConfig()
        adConfig.client = JWAdClientVast
        adConfig.schedule = [JWAdBreak(tag: "http://playertest.longtailvideo.com/adtags/preroll_newer.xml", offset: "pre"),
                             JWAdBreak(tag: "http://playertest.longtailvideo.com/adtags/preroll_newer.xml", offset: "20")]
        jwConfig.advertising = adConfig
        return JWPlayerController(config: jwConfig, delegate: nil)
    }()
    
    var analyticsObserver: AnalyticsObserver?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        analyticsObserver = AnalyticsObserver(player: player)
        player.analyticsDelegate = analyticsObserver
        
        if let playerView = player.view {
            playerPlaceholder.addSubview(playerView)
            playerView.translatesAutoresizingMaskIntoConstraints = false
            playerView.frame = playerPlaceholder.bounds.inset(by: playerPlaceholder.safeAreaInsets)
            playerView.leadingAnchor.constraint(equalTo: playerPlaceholder.leadingAnchor).isActive = true
            playerView.trailingAnchor.constraint(equalTo: playerPlaceholder.trailingAnchor).isActive = true
            playerView.topAnchor.constraint(equalTo: playerPlaceholder.topAnchor).isActive = true
            playerView.bottomAnchor.constraint(equalTo: playerPlaceholder.bottomAnchor).isActive = true
        }
    }
    
}
