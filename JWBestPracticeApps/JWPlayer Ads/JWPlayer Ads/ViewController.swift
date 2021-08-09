//
//  ViewController.swift
//  JWPlayer Ads
//
//  Created by David Almaguer on 09/08/21.
//

import UIKit
import JWPlayerKit

class ViewController: JWPlayerViewController {
    private let adUrlString = "https://playertest.longtailvideo.com/pre-60s.xml"
    private let videoUrlString = "https://playertest.longtailvideo.com/adaptive/bbbfull/bbbfull.m3u8"
    private let posterUrlString = "https://content.bitsontherun.com/thumbs/bkaovAYt-720.jpg"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the player.
        setUpPlayer()
    }

    /**
     Sets up the player with an advertising configuration.
     */
    private func setUpPlayer() {
        let videoUrl = URL(string:videoUrlString)!
        let posterUrl = URL(string:posterUrlString)!
        let adURL = URL(string: adUrlString)!

        // First, use the JWPlayerItemBuilder to create a JWPlayerItem that will be used by the player configuration.
        let playerItembuilder = JWPlayerItemBuilder()
            .file(videoUrl)
            .posterImage(posterUrl)

        var playerItem: JWPlayerItem!
        do {
            // Build the player item. This method can throw so be sure to handle the error.
            playerItem = try playerItembuilder.build()
        } catch {
            // Handle player item build failure
            print(error.localizedDescription)
            return
        }

        // Second, use the JWAdsAdvertisingConfigBuilder to create a JWAdvertisingConfig that will be used by the player configuration.
        let adConfigBuilder = JWAdsAdvertisingConfigBuilder()
            // Set the VAST tag for the builder to use.
            .tag(adURL)

        var adConfig : JWAdvertisingConfig!
        do {
            // Build the advertising configuration. This method can throw so be sure to handle the error.
            adConfig = try adConfigBuilder.build()
        } catch {
            // Handle advertising build failure
            print(error.localizedDescription)
            return
        }

        // Third, create a player config with the created JWPlayerItem and JWAdvertisingConfig
        let configBuilder = JWPlayerConfigurationBuilder()
            .playlist([playerItem])
            .advertising(adConfig)
            .autostart(true)

        var config: JWPlayerConfiguration!
        do {
            // Build the player configuration. This method can throw so be sure to handle the error.
            config = try configBuilder.build()
        } catch {
            // Handle player configuration build failure
            print(error.localizedDescription)
            return
        }

        // Lastly, use the created JWPlayerConfiguration to set up the player.
        player.configurePlayer(with: config)
    }

    //pragma MARK: - Related advertising methods

    // Reports when an event is emitted by the player.
    override func jwplayer(_ player: AnyObject, adEvent event: JWAdEvent) {
        super.jwplayer(player, adEvent: event)

        switch event.type {
        case .adBreakStart:
            print("Ad break has begun")
        case .schedule:
            print("The ad(s) has been scheduled")
        case .request:
            print("The ad has been requested")
        case .started:
            print("The ad playback has started")
        case .impression:
            print("The ad impression has been fulfilled")
        case .meta:
            print("The ad metadata is ready")
        case .clicked:
            print("The ad has been tapped")
        case .pause:
            print("The ad playback has been paused")
        case .play:
            print("The ad playback has been resumed")
        case .skipped:
            print("The ad has been skipped")
        case .complete:
            print("The ad playback has finished")
        case .adBreakEnd:
            print("The ad break has finished")
        default:
            break
        }
    }

    // This method is triggered when a time event fires for a currently playing ad.
    override func onAdTimeEvent(_ time: JWTimeData) {
        super.onAdTimeEvent(time)

        // If you are not interested in the ad time data, avoid overriding this method due to performance reasons.
    }

    // When the player encounters an ad warning within the SDK, this method is called on the delegate.
    // Ad warnings do not prevent the ad from continuing to play.
    override func jwplayer(_ player: JWPlayer, encounteredAdWarning code: UInt, message: String) {
        super.jwplayer(player, encounteredAdWarning: code, message: message)

        print("An ad warning has been encountered: (\(code))-\(message)")
    }

    // When the player encounters an ad error within the SDK, this method is called on the delegate.
    // Ad errors prevent ads from playing, but do not prevent media playback from continuing.
    override func jwplayer(_ player: JWPlayer, encounteredAdError code: UInt, message: String) {
        super.jwplayer(player, encounteredAdError: code, message: message)

        print("An ad error has been encountered: (\(code))-\(message)")
    }

}
