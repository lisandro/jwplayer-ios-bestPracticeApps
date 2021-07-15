//
//  ViewController.swift
//  VastBestPracticeApp
//
//  Created by David Perez on 23/11/20.
//  Copyright © 2020 JWPlayer. All rights reserved.

import UIKit
import JWPlayerKit

class VastViewController: JWPlayerViewController {
    private let adUrlString = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ct%3Dskippablelinear&correlator="
    private let videoUrlString = "https://playertest.longtailvideo.com/adaptive/oceans/oceans.m3u8"
    private let posterUrlString = "https://d3el35u4qe4frz.cloudfront.net/bkaovAYt-480.jpg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func setup() {
        
        // Initialize the config builder.
        let configBuilder = JWPlayerConfigurationBuilder()
        
        // If player item is nil return from setup.
        guard let item = buildPlayerItem(), let adConfig = buildAdvertising() else {
            return
        }
    
        // Set the playlist element for the builder.
        let _ = configBuilder.playlist([item]).preload(.auto).repeatContent(false)

        // Set the advertising configuration.
        let _ = configBuilder.advertising(adConfig)
        
        // Build the configuration.
        // This can throw, so use a do catch clause to handle.
        do{
            let config = try configBuilder.build()

            // Set the configuration for the player.
            player.configurePlayer(with: config)

        // Handle errors if building throws errors.
        } catch JWPlayerConfigurationBuilderError.missingPlaylist {
            print("Could not find playlist items")
        } catch {
            print("Error building configuration:", error.localizedDescription)
        }
    }

    // Build a JWAdvertisingConfig to setup the advertising for your media.
    private func buildAdvertising() -> JWAdvertisingConfig? {
        var adConfig : JWAdvertisingConfig? = nil
        // Initialize the ad URL, in this case from a String
        let adURL = URL(string: adUrlString)!

        // Initialize the builder.
        let adConfigBuilder = JWAdsAdvertisingConfigBuilder()
            // Set the VAST tag for the builder to use.
            // If tag AND schedule are set, this will throw an error.
            // Only set one of these.
            .tag(adURL)

        do {
            adConfig = try adConfigBuilder.build()
        } catch  JWAdsAdvertisingConfigBuilderError.missingAdSchedule {
            print("Either tag or schedule was not set, having one of these is required")
        } catch JWAdsAdvertisingConfigBuilderError.ambiguousAdSchedule {
            print("The schedule set is ambiguous")
        } catch {
            print(error.localizedDescription)
        }

        return adConfig
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
