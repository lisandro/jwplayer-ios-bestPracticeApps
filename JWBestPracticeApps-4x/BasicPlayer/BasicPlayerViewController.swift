//
//  ViewController.swift
//  BasicPlayer
//
//  Created by David Perez on 19/11/20.
//  Copyright © 2020 JWPlayer. All rights reserved.

import UIKit
import JWPlayerKit

/**
 Provides minimal setup for a JWPlayerViewController.
 Create an instace of this player if you need a simple JWPlayerView.
*/
class BasicPlayerViewController: JWPlayerViewController {
    private let videoUrlString = "https://playertest.longtailvideo.com/adaptive/oceans/oceans.m3u8"
    private let posterUrlString = "https://d3el35u4qe4frz.cloudfront.net/bkaovAYt-480.jpg"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view's backgroundColor to .black for better contrast.
        view.backgroundColor = .black
        setup()
    }

    // Setup the player's configuration.
    func setup(){
        
        // Initialize the config builder.
        let configBuilder = JWPlayerConfigurationBuilder()
        
        // If player item is nil return from setup.
        guard let item = buildPlayerItem() else {
            return
        }
        
        // Set the playlist element for the builder.
        let _ = configBuilder.playlist([item]).preload(.auto).repeatContent(false)

        // Build the configuration.
        // This can throw, so use a do catch clause to handle.
        do{
            let config = try configBuilder.build()

            // Set the configuration for the player.
            player.configurePlayer(with: config)

        // Handle errors if building throws errors.
        } catch {
            print("Error building configuration:", error.localizedDescription)
        }
    }

    // As with the configuration for the player we need to create a JWPlayerItem, using our JWPlayerItemBuilder().
    // This requires a file or sources.
    // Since the build method can throw, you need to handle errors if any are thrown.
    private func buildPlayerItem() -> JWPlayerItem? {
        var item: JWPlayerItem? = nil
        let videoUrl = URL(string:videoUrlString)!
        let posterUrl = URL(string:posterUrlString)!

        // To create a new JWPlayerItem, use the builder.
        let builder =  JWPlayerItemBuilder() // Initialize the builder.
            .file(videoUrl) // Set the file, which takes in a URL for the media.
            .posterImage(posterUrl) // You can set a poster image for the media.
        do {
            item = try builder.build() // Build the item. This method can throw so be sure to handle the error.
        } catch {
            print(error.localizedDescription)
        }
        return item
    }
}
