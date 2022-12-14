//
//  DRMKeyDataSource.swift
//  Offline DRM
//
//  Created by David Perez on 02/12/22.
//

import JWPlayerKit
 /**
  This manages the requests needed for online content keys.
  This will also be required during the initial creation of offline keys, since we need the certificate and playback context from your key server module.
  */
class DRMKeyDataSource: JWDRMContentKeyDataSource {
    var certificateURLStr: String? = nil
    var processSPCURLStr: String? = nil
    
    /**
     When called, this delegate method requests the identifier for the protected content to be passed through the delegate method's completion block.
     */
    func contentIdentifierForURL(_ url: URL, completionHandler handler: @escaping (Data?) -> Void) {
        let data = url.host?.data(using: .utf8)
        handler(data)
    }


    /**
     When called, this delegate method requests an Application Certificate binary which must be passed through the completion block.
     - note: The Application Certificate must be encoded with the X.509 standard with distinguished encoding rules (DER). It is obtained when registering an FPS playback app with Apple, by supplying an X.509 Certificate Signing Request linked to your private key.
     */
    func appIdentifierForURL(_ url: URL, completionHandler handler: @escaping (Data?) -> Void) {
        guard let certificateURLStr = certificateURLStr, let certificateURL = URL(string: certificateURLStr) else {
            return
        }
        let request = URLRequest(url: certificateURL)
        let task = URLSession.shared.dataTask(with: request) { (data, response, err) in
            if let err = err {
                print(err.localizedDescription)
            }
            handler(data)
        }
        task.resume()
    }

    /**
     When the key request is ready, this delegate method provides the key request data (SPC - Server Playback Context message) needed to retrieve the Content Key Context (CKC) message from your key server. The CKC message must be returned via the completion block under the response parameter.

     After your app sends the request to the server, the FPS code on the server sends the required key to the app. This key is wrapped in an encrypted message. Your app provides the encrypted message to the JWPlayerKit. The JWPlayerKit unwraps the message and decrypts the stream to enable playback on an iOS device.

     - note: For resources that may expire, specify a renewal date and the content-type in the completion block.
     */
    func contentKeyWithSPCData(_ spcData: Data, completionHandler handler: @escaping (Data?, Date?, String?) -> Void) {
        guard let processSPCURLStr = processSPCURLStr, let processSPCURL = URL(string: processSPCURLStr) else {
            return
        }
        var request = URLRequest(url: processSPCURL)
        request.httpMethod = "POST"
        request.addValue("application/octet-stream", forHTTPHeaderField: "Content-type")
        request.httpBody = spcData

        let task = URLSession.shared.dataTask(with: request) { (data, response, err) in
            if let err = err {
                print(err.localizedDescription)
            }
            handler(data, nil, "application/octet-stream")
        }
        task.resume()
    }
}
