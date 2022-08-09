//
//  ViewController.swift
//  Google IMA Ads
//
//  Created by David Almaguer on 09/08/21.
//

import UIKit
import JWPlayerKit

class ViewController: JWPlayerViewController {

    private let videoUrlString = "https://cdn.jwplayer.com/manifests/UCExCusa.m3u8"
    private let posterUrlString = "https://cdn.jwplayer.com/thumbs/CXz339Xh-720.jpg"

    override func viewDidLoad() {
        super.viewDidLoad()
        JWPlayerKitLicense.setLicenseKey("")
        // Set up the player.
        setUpPlayer()
    }

    /**
     Sets up the player with an advertising configuration.
     */
    private func setUpPlayer() {
        let videoUrl = URL(string:videoUrlString)!
        let posterUrl = URL(string:posterUrlString)!

        do {
            // First, use the JWPlayerItemBuilder to create a JWPlayerItem that will be used by the player configuration.
            let playerItem = try JWPlayerItemBuilder()
                .file(videoUrl)
                .posterImage(posterUrl)
                .build()

            // Second, use the JWImaAdvertisingConfigBuilder to create a JWAdvertisingConfig that will be used by the player configuration.
            // https://developers.google.com/interactive-media-ads/docs/sdks/ios/client-side/tags?hl=es-419
            let imaUrlString = "https://pubads.g.doubleclick.net/gampad/ads?iu=/21775744923/external/single_ad_samples&sz=640x480&cust_params=sample_ct%3Dredirecterror&ciu_szs=300x250%2C728x90&gdfp_req=1&output=vast&unviewed_position_start=1&env=vp&impl=s&correlator="
            var adConfig: JWAdvertisingConfig
            let adBreak = try JWAdBreakBuilder()
                .offset(.preroll())
                .tags([URL(string: imaUrlString)!])
                .build()
            adConfig = try JWImaAdvertisingConfigBuilder()
                .schedule([adBreak])
                .build()

            // Third, create a player config with the created JWPlayerItem and JWAdvertisingConfig.
            let config = try JWPlayerConfigurationBuilder()
                .playlist([playerItem, playerItem, playerItem])
                .advertising(adConfig)
                .autostart(true)
                .build()

            // Lastly, use the created JWPlayerConfiguration to set up the player.
            player.configurePlayer(with: config)
        } catch {
            // Builders can throw, so be sure to handle build failures.
            print(error.localizedDescription)
            return
        }
    }

    //pragma MARK: - Related advertising methods

    // Reports when an event is emitted by the player.
    override func jwplayer(_ player: AnyObject, adEvent event: JWAdEvent) {
        super.jwplayer(player, adEvent: event)

        switch event.type {
        case .adBreakStart:
            print("The ad break has begun")
        case .request:
            print("The ad(s) has been requested")
        case .started:
            print("The ad playback has started")
        case .impression:
            print("The ad impression has been fulfilled")
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
        print("An ad time \(time.duration)")
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
    
    override func jwplayer(_ player: JWPlayer, didBecomeIdleWithReason reason: JWIdleReason) {
        super.jwplayer(player, didBecomeIdleWithReason: reason)
     
        print("Did become idle: \(reason)")
    }
    
    override func jwplayer(_ player: JWPlayer, didPauseWithReason reason: JWPauseReason) {
        super.jwplayer(player, didPauseWithReason: reason)
        print("Did pause: \(reason)")
    }

}

