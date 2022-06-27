//
//  JWV2Playlist.swift
//  FeedTableViewController
//
//  Created by Amitai Blickstein on 6/26/22.
//

// This file was initially generated from JSON Schema using quicktype, MODIFY AT YOUR OWN RISK.
// To parse the JSON:
//
// let jwDecoder = JSONDecoder()
// jwDecoder.keyDecodingStrategy = .convertFromSnakeCase // so auto-coding keys work (except for "description")
// jwDecoder.dateDecodingStrategy = .secondsSince1970    // so Date decoding works
//
// let jWV2Playlist = try? decoder.decode(JWManualPlaylist.self, from: jsonData)

import Foundation

typealias Playlist = [PlaylistItem]

// MARK: - JWV2Playlist
struct JWV2Playlist: Codable {
    let title: String?
    let jwManualPlaylistDescription: String?
    let feedInstanceId: UUID?
    let feedid: String?
    let kind: PlaylistType?
    let links: Links?
    let playlist: Playlist?
    
    enum CodingKeys: String, CodingKey {
        case jwManualPlaylistDescription = "description"
    }
}

enum PlaylistType: String {
    case MANUAL
    case DYNAMIC
}

// MARK: - Links
struct Links: Codable {
    let first: URL?
    let last: URL?
}

// MARK: - PlaylistItem
struct PlaylistItem: Codable {
    let playlistItemDescription: String?
    let duration: Int?
    let feedid: String?
    let image: URL?
    let images: [Image]?
    let link: URL?
    let mediaid: String?
    let pubdate: Date?
    let sources: [Source]?
    let tags: String?
    var tagsArray: [String] = tags?.split(separator: ",") ?? []
    let title: String?
    let tracks: [Track]?
    let variations: Any?
    
    enum CodingKeys: String, CodingKey {
        case playlistItemDescription = "description"
    }
}

// MARK: - Image
struct Image: Codable {
    let src: URL?
    let type: SourceType?
    let width: Int?
}

// MARK: - Source
struct Source: Codable {
    let bitrate: Int?
    let file: URL?
    let filesize: Int?
    let framerate: Int?
    let height: Int?
    let label: String?
    let type: SourceType?
    let width: Int?
}

// It's a shame that UTTypeReference is not Decodable
enum SourceType: String, Codable {
    case applicationVndAppleMpegurl = "application/vnd.apple.mpegurl"
    case audioMp4  = "audio/mp4"
    case videoMp4  = "video/mp4"
    case imageJpeg = "image/jpeg"
    case imagePng  = "image/png"
}

// MARK: - Track
struct Track: Codable {
    let file: URL?
    let kind: TrackType?
    let label: String?
}

enum TrackType: String, Codable {
    case thumbnails = "thumbnails"
    case captions   = "captions"
}
