//
//  FeedTableViewController.swift
//  FeedTableViewController
//
//  Created by Amitai Blickstein on 6/26/22.
//

import JWPlayerKit
import UIKit

class FeedTableViewController: UITableViewController {
    /// Single player and player view
    private let playerView = JWPlayerView()
    private var player: JWPlayer { playerView.player }
    private var playlistItems: [JWPlayerItem] = []
    private var playlistLoaded = false
    /// Instantiated with our mock/hard-coded playlist.
    private var viewModel = FeedViewModel(withItems: [])

    /// Helps to handle media playback when navigating through the feed.
    private var page: Int = -1 {
        didSet {
            guard page != oldValue else {
                return
            }

            let previousIndexPath = IndexPath(row: oldValue, section: 0)
            let indexPath = IndexPath(row: page, section: 0)

            if let cell = tableView.cellForRow(at: previousIndexPath) as? PlayerItemCell {
                cell.pausePlayback()
            }

            if let cell = tableView.cellForRow(at: indexPath) as? PlayerItemCell {
                cell.startPlayback()
            }

            // Add more rows to the data source when we hit the end.
            Task {
                if page == viewModel.count - 1 {
                    viewModel.appendItems(fromPlaylist: Playlist.bpaManual)
                }
            }
        }
    }

    var autostartFirstTime: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        
        // Register the custom cell view.
        let feedNib = UINib(nibName: viewModel.cellNibName, bundle: .main)
        tableView.register(feedNib, forCellReuseIdentifier: viewModel.cellReuseIdentifier)
        
        // Various stylistic options.
        tableView.scrollsToTop = false
        tableView.isPagingEnabled = true
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = view.bounds.inset(by: view.safeAreaInsets).height

        // Configure player with playlistManual
        if let config = Playlist.playlistManual {
            playerView.player.delegate = self
            playerView.player.playbackStateDelegate = self
            playerView.player.configurePlayer(with: config)
        }

        Task { @MainActor in
            calculateCurrentPage()
        }
    }

    
    // MARK: - UITableViewDataSource implementation

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        playlistItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.cellReuseIdentifier, for: indexPath)
        if let cell = cell as? PlayerItemCell {
            cell.descriptionLabel.text = "video #\(indexPath.row + 1)"
            cell.titleLabel.text = playlistItems[safe: indexPath.row]?.title
            // Move playerView to this cell if it's the current page
            if indexPath.row == page {
                //TODO: Review if we can avoid set a new player and reuse the existing one
                cell.setPlayerView(playerView)
                player.loadPlayerItemAt(index: page)
            } else {
                cell.removePlayerView()
            }
        }
        return cell
    }

    override func scrollViewDidEndDecelerating(_: UIScrollView) {
        calculateCurrentPage()
        movePlayerToCurrentCell()
    }

    override func scrollViewDidEndDragging(_: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            calculateCurrentPage()
            movePlayerToCurrentCell()
        }
    }

    func calculateCurrentPage() {
        let pageHeight = tableView.frame.height
        page = Int((tableView.contentOffset.y + pageHeight / 2) / pageHeight)
    }

    @MainActor
    private func movePlayerToCurrentCell() {
        if let cell = tableView.cellForRow(at: IndexPath(row: page, section: 0)) as? PlayerItemCell {
            cell.setPlayerView(playerView)
            player.loadPlayerItemAt(index: page)
        }
    }
}

// MARK: - JWPlayerDelegate

extension FeedTableViewController: JWPlayerStateDelegate {
    
    func jwplayer(_ player: any JWPlayer, didLoadPlaylist playlist: [JWPlayerItem]) {
        // Called when the playlist is loaded
        playlistItems = playlist
        viewModel = FeedViewModel(withItems: playlist)
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.movePlayerToCurrentCell()
        }
    }
    
    func jwplayerContentWillComplete(_ player: any JWPlayerKit.JWPlayer) {
        
    }
    
    func jwplayer(_ player: any JWPlayerKit.JWPlayer, willPlayWithReason reason: JWPlayerKit.JWPlayReason) {
        
    }
    
    func jwplayer(_ player: any JWPlayerKit.JWPlayer, isBufferingWithReason reason: JWPlayerKit.JWBufferReason) {
        
    }
    
    func jwplayerContentIsBuffering(_ player: any JWPlayerKit.JWPlayer) {
        
    }
    
    func jwplayer(_ player: any JWPlayerKit.JWPlayer, updatedBuffer percent: Double, position time: JWPlayerKit.JWTimeData) {
        
    }
    
    func jwplayerContentDidComplete(_ player: any JWPlayerKit.JWPlayer) {
        
    }
    
    func jwplayer(_ player: any JWPlayerKit.JWPlayer, didFinishLoadingWithTime loadTime: TimeInterval) {
        
    }
    
    func jwplayer(_ player: any JWPlayerKit.JWPlayer, isPlayingWithReason reason: JWPlayerKit.JWPlayReason) {
        
    }
    
    func jwplayer(_ player: any JWPlayerKit.JWPlayer, isAttemptingToPlay playlistItem: JWPlayerKit.JWPlayerItem, reason: JWPlayerKit.JWPlayReason) {
        
    }
    
    func jwplayer(_ player: any JWPlayerKit.JWPlayer, didPauseWithReason reason: JWPlayerKit.JWPauseReason) {
        
    }
    
    func jwplayer(_ player: any JWPlayerKit.JWPlayer, didBecomeIdleWithReason reason: JWPlayerKit.JWIdleReason) {
        
    }
    
    func jwplayer(_ player: any JWPlayerKit.JWPlayer, isVisible: Bool) {
        
    }
    
    func jwplayer(_ player: any JWPlayerKit.JWPlayer, didLoadPlaylistItem item: JWPlayerKit.JWPlayerItem, at index: UInt) {
        
    }
    
    func jwplayerPlaylistHasCompleted(_ player: any JWPlayerKit.JWPlayer) {
        
    }
    
    func jwplayer(_ player: any JWPlayerKit.JWPlayer, usesMediaType type: JWPlayerKit.JWMediaType) {
        
    }
    
    func jwplayer(_ player: any JWPlayerKit.JWPlayer, seekedFrom oldPosition: TimeInterval, to newPosition: TimeInterval) {
        
    }
    
    func jwplayerHasSeeked(_ player: any JWPlayerKit.JWPlayer) {
        
    }
    
    func jwplayer(_ player: any JWPlayerKit.JWPlayer, playbackRateChangedTo rate: Double, at time: TimeInterval) {
        
    }
    
    func jwplayer(_ player: any JWPlayerKit.JWPlayer, updatedCues cues: [JWPlayerKit.JWCue]) {
        
    }

}

extension FeedTableViewController: JWPlayerDelegate {
    func jwplayerIsReady(_ player: any JWPlayerKit.JWPlayer) {
        
    }
    
    func jwplayer(_ player: any JWPlayerKit.JWPlayer, failedWithError code: UInt, message: String) {
        
    }
    
    func jwplayer(_ player: any JWPlayerKit.JWPlayer, failedWithSetupError code: UInt, message: String) {
        
    }
    
    func jwplayer(_ player: any JWPlayerKit.JWPlayer, encounteredWarning code: UInt, message: String) {
        
    }
    
    func jwplayer(_ player: any JWPlayerKit.JWPlayer, encounteredAdWarning code: UInt, message: String) {
        
    }
    
    func jwplayer(_ player: any JWPlayerKit.JWPlayer, encounteredAdError code: UInt, message: String) {
        
    }

}

extension FeedTableViewController: FeedViewModelDelegate {
    /// When new items are added to the data source, this will be called to reload the appropriate rows.
    func didAddNewItemsToViewModel(with newIndicesToReload: [Int]?) {
        let newIndexPaths = (newIndicesToReload ?? [])
            .map { IndexPath(row: $0, section: 0) }

        didAddNewRows(withIndexPaths: newIndexPaths)
    }

    @MainActor
    private func didAddNewRows(withIndexPaths newIndexPaths: [IndexPath]) {
        tableView.insertRows(at: newIndexPaths, with: .none)
    }
}

// MARK: - Safe array subscript

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
