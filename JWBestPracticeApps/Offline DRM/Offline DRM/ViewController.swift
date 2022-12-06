//
//  ViewController.swift
//  Offline DRM
//
//  Created by David Perez on 02/12/22.
//

import JWPlayerKit
import AVFoundation

class ViewController: UIViewController, AVAssetDownloadDelegate {
    // MARK: - IBOutlet
    /// Presents the current state of the offline media.
    @IBOutlet private weak var stateLabel: UILabel?
    
    // MARK: - Properties
   
    /// The key for requesting the data from UserDefaults
    private let savedDataKey = "localVideoFile"
    // MARK: - DRM management properties
    /// The content key loader.
    private var contentLoader: JWDRMContentLoader?
    private let keyManager: JWDRMContentKeyManager = DRMKeyManager()
    private let keyDataSource: DRMKeyDataSource = DRMKeyDataSource()
    // MARK: - Playlist properties
    // The playlist signed URL for DRM protected content.
    private let playlistURL = "<#T##String#>"
    /// The video file from the signed URL, this gets set after parsing the playlist.
    private var videoFile = ""
    /// The location in memory for the local video, this gets set when downloading the asset. Not directly used.
    private var localVideoFile: URL? = nil
    /// The local video URL, this gets set from memory if the video is saved and used as the locator for memory videos. Bookmarked data allows us to access the video file in memory since it is stored in a secure location.
    private var localURL: URL? {
        let persistedData = UserDefaults.standard.data(forKey: savedDataKey)
        guard let boomarkData = persistedData else {
            return nil
        }
        var dataStaleStatus = false
        let url = try? URL(resolvingBookmarkData: boomarkData,
                           bookmarkDataIsStale: &dataStaleStatus)
        return dataStaleStatus ? nil : url
    }
    /// The player interface, this is from the JWPlayerViewController embedded in a container view.a
    private var player: JWPlayerProtocol? = nil
    
    /// The AVAssetDownloadURLSession to use for managing AVAssetDownloadTasks.
    private var assetDownloadURLSession: AVAssetDownloadURLSession!
    /// The delegate queue for the AVAssetDownloadURLSession
    private let delegateQueue = OperationQueue()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /// The keys can be pre-loaded by calling load on the content loader.
        let url = URL(string: playlistURL)!
        contentLoader = JWDRMContentLoader(dataSource: keyDataSource, keyManager: keyManager)
        self.contentLoader?.load(playlist: url)
        
        // We construct a playlist either from the remote asset or a local asset if it is saved.
        var config: JWPlayerConfiguration!
        
        if let localURL = localURL {
            config = self.getPlaylist(local: localURL)
            // Updates the UI to reflect that the asset is already downloaded.
            stateLabel?.text = "Saved"
        } else {
            config = self.getPlaylist(remote: url)
        }
        // We set the content loader to the player.
        self.player?.contentLoader = self.contentLoader
        // We configure the player.
        self.player?.configurePlayer(with: config)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create the configuration for the AVAssetDownloadURLSession.
        let backgroundConfiguration = URLSessionConfiguration.background(withIdentifier: "AAPL-Identifier")
        assetDownloadURLSession = AVAssetDownloadURLSession(configuration: backgroundConfiguration,
                                                            assetDownloadDelegate: self, delegateQueue: delegateQueue)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let playerViewController = segue.destination as? JWPlayerViewController else {
            return
        }
        // Set this controller's player reference to the embedded JWPlayerViewController's.
        self.player = playerViewController.player
    }
    
    func getPlaylist(remote url: URL) -> JWPlayerConfiguration? {
        let sem = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, err in
            defer {
                sem.signal()
            }
            guard let self = self else {
                return
            }
            if let error = err {
                fatalError("Playlist URL request failed: \(error.localizedDescription)")
            }
            do {
                let playlist = try JSONDecoder().decode(DRMPlaylist.self, from: data!)
                guard let source = playlist.playlist.first?.sources.first(where: { $0.type == "application/vnd.apple.mpegurl" }) else {
                    return
                }
                // After parsing the playlist, set the current video file
                self.videoFile = source.file
                // Set the certificate URL we will need for for the JWDRMKeyDataSource
                self.keyDataSource.certificateURLStr = source.drm.fairplay?.certificateURL
                // Set the process SPC URL we will need for for the JWDRMKeyDataSource
                self.keyDataSource.processSPCURLStr = source.drm.fairplay?.processSpcURL
            } catch {
                print("Error decoding data from playlist URL", error.localizedDescription)
            }
        }
        task.resume()
        sem.wait()
        // Create a configuration from the video file.
        let fileURL = URL(string: videoFile)!
        var config: JWPlayerConfiguration? = nil
        do {
            let playerItem = try JWPlayerItemBuilder().file(fileURL).build()
            config = try JWPlayerConfigurationBuilder()
                .playlist(items: [playerItem]).build()
        } catch {
            // Handle any error thrown during the configuration build
            print("Error encountered while building the configuration:", error.localizedDescription)
        }
       
        return config
    }
    
    func getPlaylist(local url: URL) -> JWPlayerConfiguration? {
        var config: JWPlayerConfiguration? = nil
        do {
            let playerItem = try JWPlayerItemBuilder().file(url).build()
            config = try JWPlayerConfigurationBuilder()
                .playlist(items: [playerItem]).build()
        } catch {
            // Handle any error thrown during the configuration build
            print("Error encountered while building the configuration:", error.localizedDescription)
        }

        return config
    }
    
    /// Triggers the initial AVAssetDownloadTask for a given Asset.
    func downloadStream(for asset: AVURLAsset) {
        // Get the default media selections for the asset's media selection groups.
        let preferredMediaSelection = asset.preferredMediaSelection
        
        /*
         Creates and initializes an AVAggregateAssetDownloadTask to download multiple AVMediaSelections
         on an AVURLAsset.
         
         For the initial download, we ask the URLSession for an AVAssetDownloadTask with a minimum bitrate
         corresponding with one of the lower bitrate variants in the asset.
         */
        guard let task =
                assetDownloadURLSession.aggregateAssetDownloadTask(with: asset,
                                                                   mediaSelections: [preferredMediaSelection],
                                                                   assetTitle: asset.description,
                                                                   assetArtworkData: nil,
                                                                   options:
                                                                    [AVAssetDownloadTaskMinimumRequiredMediaBitrateKey: 265_000]) else {
            return
        }
        
        task.resume()
    }
    
    func urlSession(_ session: URLSession, aggregateAssetDownloadTask: AVAggregateAssetDownloadTask, didCompleteFor mediaSelection: AVMediaSelection) {
        DispatchQueue.main.async { [weak self] in
            self?.stateLabel?.text = "Saved"
        }
        do {
            let data = try localVideoFile?.bookmarkData()
            UserDefaults.standard.set(data, forKey: savedDataKey)
        } catch {
            print("Error saving bookmark data")
        }
        
    }
    
    func urlSession(_ session: URLSession, aggregateAssetDownloadTask: AVAggregateAssetDownloadTask, willDownloadTo location: URL) {
        localVideoFile = location
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print("Error while downloading the asset: ", error.localizedDescription)
        }
    }
    
    @IBAction func downloadStream(_ sender: UIButton) {
        guard let video = URL(string: videoFile) else {
            return
        }
        // If we have a video file, start downloading the asset.
        let asset = AVURLAsset(url: video)
        downloadStream(for: asset)
        stateLabel?.text = "Downloading"
    }
}

