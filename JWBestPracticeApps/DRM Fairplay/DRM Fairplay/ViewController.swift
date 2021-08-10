//
//  ViewController.swift
//  DRM Fairplay
//
//  Created by David Almaguer on 06/08/21.
//

import UIKit
import JWPlayerKit

private let EZDRMLicenseAPIEndpoint = "https://fps.ezdrm.com/api/licenses"
private let EZDRMCertificateEndpoint = "https://fps.ezdrm.com/demo/video/eleisure.cer"
private let EZDRMVideoEndpoint = "https://fps.ezdrm.com/demo/video/ezdrm.m3u8"

class ViewController: JWPlayerViewController,
                      JWDRMContentKeyDataSource {

    var contentUUID: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the player.
        setUpPlayer()
    }

    /**
     Sets up the player with a DRM configuration.
     */
    private func setUpPlayer() {
        // Open a do-catch block to catch possible errors with the builders.
        do {
            let videoUrl = URL(string:EZDRMVideoEndpoint)!

            // First, use the JWPlayerItemBuilder to create a JWPlayerItem that will be used by the player configuration.
            let playerItem = JWPlayerItemBuilder()
                .file(videoUrl)
                .build()

            // Second, create a player config with the created JWPlayerItem.
            let config = JWPlayerConfigurationBuilder()
                .playlist([playerItem])
                .autostart(true)
                .build()

            // Third, set the data source class. This class conforms to JWDRMContentKeyDataSource, and defines methods which affect DRM.
            player.contentKeyDataSource = self

            // Lastly, use the created JWPlayerConfiguration to set up the player.
            player.configurePlayer(with: config)
        } catch {
            // Builders can throw, so be sure to handle the build failures.
            print(error.localizedDescription)
            return
        }
    }

    // MARK: JWDRMContentKeyDataSource

    /**
     When called, this delegate method requests the identifier for the protected content to be passed through the delegate method's completion block.
     */
    func contentIdentifierForURL(_ url: URL, completionHandler handler: @escaping (Data?) -> Void) {
        let uuid = "content-uuid"
        let uuidData = uuid.data(using: .utf8)
        handler(uuidData)
    }


    /**
     When called, this delegate method requests an Application Certificate binary which must be passed through the completion block.
     - note: The Application Certificate must be encoded with the X.509 standard with distinguished encoding rules (DER). It is obtained when registering an FPS playback app with Apple, by supplying an X.509 Certificate Signing Request linked to your private key.
     */
    func appIdentifierForURL(_ url: URL, completionHandler handler: @escaping (Data?) -> Void) {
        print("url: \(url)")
        guard let certUrl = URL(string: EZDRMCertificateEndpoint),
              let appIdData = try? Data(contentsOf: certUrl) else {
            handler(nil)
            return
        }
        handler(appIdData)
    }

    /**
     When the key request is ready, this delegate method provides the key request data (SPC - Server Playback Context message) needed to retrieve the Content Key Context (CKC) message from your key server. The CKC message must be returned via the completion block under the response parameter.

     After your app sends the request to the server, the FPS code on the server sends the required key to the app. This key is wrapped in an encrypted message. Your app provides the encrypted message to the JWPlayerKit. The JWPlayerKit unwraps the message and decrypts the stream to enable playback on an iOS device.

     - note: For resources that may expire, specify a renewal date and the content-type in the completion block.
     */
    func contentKeyWithSPCData(_ spcData: Data, completionHandler handler: @escaping (Data?, Date?, String?) -> Void) {
        guard let contentUUID = self.contentUUID else {
            handler(nil, nil, nil)
            return
        }

        let currentTime = Date().timeIntervalSince1970
        let licenseApiPath = EZDRMLicenseAPIEndpoint.appendingFormat("/%@?p1=%li", contentUUID, currentTime)
        var ckcRequest = URLRequest(url: URL(string: licenseApiPath)!)
        ckcRequest.httpMethod = "POST"
        ckcRequest.httpBody = spcData
        ckcRequest.addValue("application/octet-stream", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: ckcRequest) { (data, response, error) in
            guard error == nil, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                handler(nil, nil, nil)
                return
            }
            handler(data, nil, nil)
        }.resume()
    }
}
