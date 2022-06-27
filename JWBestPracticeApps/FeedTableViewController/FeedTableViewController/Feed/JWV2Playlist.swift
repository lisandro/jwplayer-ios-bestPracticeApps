//
//  JWV2Playlist.swift
//  FeedTableViewController
//
//  Created by Amitai Blickstein on 6/26/22.
//

import Foundation


// MARK: - JWV2Playlist

/// This file was initially generated from JSON Schema using quicktype, MODIFY AT YOUR OWN RISK.
/// To parse the JSON:
///
/// ```
/// let jwDecoder = JSONDecoder()
/// jwDecoder.keyDecodingStrategy  = .convertFromSnakeCase // so auto-coding keys work (except for "description")
/// jwDecoder.dateDecodingStrategy = .secondsSince1970     // so Date decoding works
///
/// let jWV2Playlist = try? decoder.decode(JWManualPlaylist.self, from: jsonData)
struct JWV2Playlist: Decodable {
    let title: String?
    let description: String?
    let feedInstanceId: UUID?
    let feedid: String?
    let kind: PlaylistType?
    let links: Links?
    let playlist: [PlaylistItem]?
    
    static let jwDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy  = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()
    
    var jwDecoder: JSONDecoder { Self.jwDecoder }
    
    // For demo
    static let exampleManualPlaylist: JWV2Playlist = {
        try! jwDecoder.decode(Self.self, from: exampleManualPlaylistResponse.data(using: .utf8)!)
    }()
}

enum PlaylistType: String, Decodable {
    case MANUAL
    case DYNAMIC
}

// MARK: - Links
struct Links: Decodable {
    let first: URL?
    let last: URL?
}

// MARK: - PlaylistItem
struct PlaylistItem: Decodable {
    let description: String?
    let duration: Int?
    let feedid: String?
    let image: URL?
    let images: [Image]?
    let link: URL?
    let mediaid: String?
    let pubdate: Date?
    let sources: [Source]?
    let title: String?
    let tracks: [Track]?
    let tags: String?
    var tagsArray: [String] {
        tags?
            .split(separator: ",")
            .compactMap {String($0)}
        ?? []
    }
    // TODO: Implement this
//    let variations: Any?
}

// MARK: - Image
struct Image: Decodable {
    let src: URL?
    let type: SourceType?
    let width: Int?
}

// MARK: - Source
struct Source: Decodable {
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
enum SourceType: String, Decodable {
    case applicationVndAppleMpegurl = "application/vnd.apple.mpegurl"
    case audioMp4  = "audio/mp4"
    case videoMp4  = "video/mp4"
    case imageJpeg = "image/jpeg"
    case imagePng  = "image/png"
}

// MARK: - Track
struct Track: Decodable {
    let file: URL?
    let kind: TrackType?
    let label: String?
}

enum TrackType: String, Decodable {
    case thumbnails = "thumbnails"
    case captions   = "captions"
}


// MARK: - exampleManualPlaylistResponse

/// Response from a call to the Delivery API, `https://cdn.jwplayer.com/v2/playlists/d7sk9orq`
fileprivate let exampleManualPlaylistResponse = """
{
   "title": "BPA Manual Playlist",
   "description": "",
   "kind": "MANUAL",
   "feedid": "d7sk9orq",
   "links": {
      "first": "https://cdn.jwplayer.com/v2/playlists/d7sk9orq?format=json&internal=false&page_offset=1&page_limit=500",
      "last": "https://cdn.jwplayer.com/v2/playlists/d7sk9orq?format=json&internal=false&page_offset=1&page_limit=500"
   },
   "playlist": [
      {
         "title": "Big Buck Bunny 33s",
         "mediaid": "YuJG5ygn",
         "link": "https://cdn.jwplayer.com/previews/YuJG5ygn",
         "image": "https://cdn.jwplayer.com/v2/media/YuJG5ygn/poster.jpg?width=720",
         "images": [
            {
               "src": "https://cdn.jwplayer.com/v2/media/YuJG5ygn/poster.jpg?width=320",
               "width": 320,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/YuJG5ygn/poster.jpg?width=480",
               "width": 480,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/YuJG5ygn/poster.jpg?width=640",
               "width": 640,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/YuJG5ygn/poster.jpg?width=720",
               "width": 720,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/YuJG5ygn/poster.jpg?width=1280",
               "width": 1280,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/YuJG5ygn/poster.jpg?width=1920",
               "width": 1920,
               "type": "image/jpeg"
            }
         ],
         "feedid": "d7sk9orq",
         "duration": 33,
         "pubdate": 1656013013,
         "description": "Big Buck Bunny ~30s trailer",
         "tags": "feedtableview,bpa,ios",
         "sources": [
            {
               "file": "https://cdn.jwplayer.com/manifests/YuJG5ygn.m3u8",
               "type": "application/vnd.apple.mpegurl"
            },
            {
               "file": "https://cdn.jwplayer.com/videos/YuJG5ygn-v713jOfL.mp4",
               "type": "video/mp4",
               "height": 180,
               "width": 320,
               "label": "180p",
               "bitrate": 293047,
               "filesize": 1208820,
               "framerate": 25
            },
            {
               "file": "https://cdn.jwplayer.com/videos/YuJG5ygn-J0W48ONu.m4a",
               "type": "audio/mp4",
               "label": "AAC Audio",
               "bitrate": 115414,
               "filesize": 476084
            }
         ],
         "tracks": [
            {
               "file": "https://cdn.jwplayer.com/tracks/2z1S8bpp.vtt",
               "kind": "captions",
               "label": "Bunny-en"
            },
            {
               "file": "https://cdn.jwplayer.com/tracks/a8RhUYRe.vtt",
               "kind": "captions",
               "label": "Duplicate Bunny-en "
            },
            {
               "file": "https://cdn.jwplayer.com/strips/YuJG5ygn-120.vtt",
               "kind": "thumbnails"
            }
         ],
         "variations": {}
      },
      {
         "title": "Stock-footage-office-chair-race-young-guys-have-fun-in-the-office-during-a-break-games-of-businessmen-from",
         "mediaid": "XKvnATBz",
         "link": "https://cdn.jwplayer.com/previews/XKvnATBz",
         "image": "https://cdn.jwplayer.com/v2/media/XKvnATBz/poster.jpg?width=720",
         "images": [
            {
               "src": "https://cdn.jwplayer.com/v2/media/XKvnATBz/poster.jpg?width=320",
               "width": 320,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/XKvnATBz/poster.jpg?width=480",
               "width": 480,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/XKvnATBz/poster.jpg?width=640",
               "width": 640,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/XKvnATBz/poster.jpg?width=720",
               "width": 720,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/XKvnATBz/poster.jpg?width=1280",
               "width": 1280,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/XKvnATBz/poster.jpg?width=1920",
               "width": 1920,
               "type": "image/jpeg"
            }
         ],
         "feedid": "d7sk9orq",
         "duration": 14,
         "pubdate": 1656015293,
         "description": "",
         "tags": "feedtableview,bpa,ios",
         "sources": [
            {
               "file": "https://cdn.jwplayer.com/manifests/XKvnATBz.m3u8",
               "type": "application/vnd.apple.mpegurl"
            },
            {
               "file": "https://cdn.jwplayer.com/videos/XKvnATBz-v713jOfL.mp4",
               "type": "video/mp4",
               "height": 180,
               "width": 320,
               "label": "180p",
               "bitrate": 97962,
               "filesize": 171434,
               "framerate": 25
            },
            {
               "file": "https://cdn.jwplayer.com/videos/XKvnATBz-1HebiUkE.mp4",
               "type": "video/mp4",
               "height": 270,
               "width": 480,
               "label": "270p",
               "bitrate": 176431,
               "filesize": 308755,
               "framerate": 25
            }
         ],
         "tracks": [
            {
               "file": "https://cdn.jwplayer.com/strips/XKvnATBz-120.vtt",
               "kind": "thumbnails"
            }
         ],
         "variations": {}
      },
      {
         "title": "Stock-footage-bright-sun-light-ray-flare-n-sunbeam-shining-through-colorful-dark-cumulus-cloud-on-beautiful-sunny",
         "mediaid": "FCEcttZF",
         "link": "https://cdn.jwplayer.com/previews/FCEcttZF",
         "image": "https://cdn.jwplayer.com/v2/media/FCEcttZF/poster.jpg?width=720",
         "images": [
            {
               "src": "https://cdn.jwplayer.com/v2/media/FCEcttZF/poster.jpg?width=320",
               "width": 320,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/FCEcttZF/poster.jpg?width=480",
               "width": 480,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/FCEcttZF/poster.jpg?width=640",
               "width": 640,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/FCEcttZF/poster.jpg?width=720",
               "width": 720,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/FCEcttZF/poster.jpg?width=1280",
               "width": 1280,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/FCEcttZF/poster.jpg?width=1920",
               "width": 1920,
               "type": "image/jpeg"
            }
         ],
         "feedid": "d7sk9orq",
         "duration": 30,
         "pubdate": 1656014836,
         "description": "",
         "tags": "feedtableview,bpa,ios",
         "sources": [
            {
               "file": "https://cdn.jwplayer.com/manifests/FCEcttZF.m3u8",
               "type": "application/vnd.apple.mpegurl"
            },
            {
               "file": "https://cdn.jwplayer.com/videos/FCEcttZF-v713jOfL.mp4",
               "type": "video/mp4",
               "height": 180,
               "width": 320,
               "label": "180p",
               "bitrate": 320513,
               "filesize": 1201924,
               "framerate": 30
            },
            {
               "file": "https://cdn.jwplayer.com/videos/FCEcttZF-1HebiUkE.mp4",
               "type": "video/mp4",
               "height": 270,
               "width": 480,
               "label": "270p",
               "bitrate": 489598,
               "filesize": 1835995,
               "framerate": 30
            },
            {
               "file": "https://cdn.jwplayer.com/videos/FCEcttZF-J0W48ONu.m4a",
               "type": "audio/mp4",
               "label": "AAC Audio",
               "bitrate": 114277,
               "filesize": 428541
            }
         ],
         "tracks": [
            {
               "file": "https://cdn.jwplayer.com/strips/FCEcttZF-120.vtt",
               "kind": "thumbnails"
            }
         ],
         "variations": {}
      },
      {
         "title": "Stock-footage-funny-young-man-in-super-hero-costume-is-running-in-office-doing-high-five-with-colleagues-wearing",
         "mediaid": "M2U5cjk2",
         "link": "https://cdn.jwplayer.com/previews/M2U5cjk2",
         "image": "https://cdn.jwplayer.com/v2/media/M2U5cjk2/poster.jpg?width=720",
         "images": [
            {
               "src": "https://cdn.jwplayer.com/v2/media/M2U5cjk2/poster.jpg?width=320",
               "width": 320,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/M2U5cjk2/poster.jpg?width=480",
               "width": 480,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/M2U5cjk2/poster.jpg?width=640",
               "width": 640,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/M2U5cjk2/poster.jpg?width=720",
               "width": 720,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/M2U5cjk2/poster.jpg?width=1280",
               "width": 1280,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/M2U5cjk2/poster.jpg?width=1920",
               "width": 1920,
               "type": "image/jpeg"
            }
         ],
         "feedid": "d7sk9orq",
         "duration": 14,
         "pubdate": 1656015293,
         "description": "",
         "tags": "feedtableview,bpa,ios",
         "sources": [
            {
               "file": "https://cdn.jwplayer.com/manifests/M2U5cjk2.m3u8",
               "type": "application/vnd.apple.mpegurl"
            },
            {
               "file": "https://cdn.jwplayer.com/videos/M2U5cjk2-v713jOfL.mp4",
               "type": "video/mp4",
               "height": 180,
               "width": 320,
               "label": "180p",
               "bitrate": 376581,
               "filesize": 659017,
               "framerate": 25
            },
            {
               "file": "https://cdn.jwplayer.com/videos/M2U5cjk2-1HebiUkE.mp4",
               "type": "video/mp4",
               "height": 270,
               "width": 480,
               "label": "270p",
               "bitrate": 584451,
               "filesize": 1022790,
               "framerate": 25
            }
         ],
         "tracks": [
            {
               "file": "https://cdn.jwplayer.com/strips/M2U5cjk2-120.vtt",
               "kind": "thumbnails"
            }
         ],
         "variations": {}
      },
      {
         "title": "Stock-footage-aerial-shot-expensive-luxury-sport-car-suv-driving-on-the-sunny-clean-road-highway-to-mountains",
         "mediaid": "Yj1Me5ji",
         "link": "https://cdn.jwplayer.com/previews/Yj1Me5ji",
         "image": "https://cdn.jwplayer.com/v2/media/Yj1Me5ji/poster.jpg?width=720",
         "images": [
            {
               "src": "https://cdn.jwplayer.com/v2/media/Yj1Me5ji/poster.jpg?width=320",
               "width": 320,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/Yj1Me5ji/poster.jpg?width=480",
               "width": 480,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/Yj1Me5ji/poster.jpg?width=640",
               "width": 640,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/Yj1Me5ji/poster.jpg?width=720",
               "width": 720,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/Yj1Me5ji/poster.jpg?width=1280",
               "width": 1280,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/Yj1Me5ji/poster.jpg?width=1920",
               "width": 1920,
               "type": "image/jpeg"
            }
         ],
         "feedid": "d7sk9orq",
         "duration": 13,
         "pubdate": 1656014836,
         "description": "",
         "tags": "feedtableview,bpa,ios",
         "sources": [
            {
               "file": "https://cdn.jwplayer.com/manifests/Yj1Me5ji.m3u8",
               "type": "application/vnd.apple.mpegurl"
            },
            {
               "file": "https://cdn.jwplayer.com/videos/Yj1Me5ji-v713jOfL.mp4",
               "type": "video/mp4",
               "height": 180,
               "width": 320,
               "label": "180p",
               "bitrate": 306211,
               "filesize": 497594,
               "framerate": 30
            },
            {
               "file": "https://cdn.jwplayer.com/videos/Yj1Me5ji-1HebiUkE.mp4",
               "type": "video/mp4",
               "height": 270,
               "width": 480,
               "label": "270p",
               "bitrate": 576270,
               "filesize": 936439,
               "framerate": 30
            }
         ],
         "tracks": [
            {
               "file": "https://cdn.jwplayer.com/strips/Yj1Me5ji-120.vtt",
               "kind": "thumbnails"
            }
         ],
         "variations": {}
      },
      {
         "title": "Stock-footage-young-caucasian-boy-in-national-chinese-dress-is-practicing-kung-fu-wushu-tai-chi-form-nanquan",
         "mediaid": "N7thLVIE",
         "link": "https://cdn.jwplayer.com/previews/N7thLVIE",
         "image": "https://cdn.jwplayer.com/v2/media/N7thLVIE/poster.jpg?width=720",
         "images": [
            {
               "src": "https://cdn.jwplayer.com/v2/media/N7thLVIE/poster.jpg?width=320",
               "width": 320,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/N7thLVIE/poster.jpg?width=480",
               "width": 480,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/N7thLVIE/poster.jpg?width=640",
               "width": 640,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/N7thLVIE/poster.jpg?width=720",
               "width": 720,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/N7thLVIE/poster.jpg?width=1280",
               "width": 1280,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/N7thLVIE/poster.jpg?width=1920",
               "width": 1920,
               "type": "image/jpeg"
            }
         ],
         "feedid": "d7sk9orq",
         "duration": 13,
         "pubdate": 1656015293,
         "description": "",
         "tags": "feedtableview,bpa,ios",
         "sources": [
            {
               "file": "https://cdn.jwplayer.com/manifests/N7thLVIE.m3u8",
               "type": "application/vnd.apple.mpegurl"
            },
            {
               "file": "https://cdn.jwplayer.com/videos/N7thLVIE-v713jOfL.mp4",
               "type": "video/mp4",
               "height": 180,
               "width": 320,
               "label": "180p",
               "bitrate": 292752,
               "filesize": 475722,
               "framerate": 60
            },
            {
               "file": "https://cdn.jwplayer.com/videos/N7thLVIE-1HebiUkE.mp4",
               "type": "video/mp4",
               "height": 270,
               "width": 480,
               "label": "270p",
               "bitrate": 516769,
               "filesize": 839750,
               "framerate": 60
            }
         ],
         "tracks": [
            {
               "file": "https://cdn.jwplayer.com/strips/N7thLVIE-120.vtt",
               "kind": "thumbnails"
            }
         ],
         "variations": {}
      },
      {
         "title": "Stock-footage-happy-boy-runs-wheat-field-holding-airplane-in-his-hand-his-dog-jack-russell-terrier-on-summer",
         "mediaid": "SgKzo48g",
         "link": "https://cdn.jwplayer.com/previews/SgKzo48g",
         "image": "https://cdn.jwplayer.com/v2/media/SgKzo48g/poster.jpg?width=720",
         "images": [
            {
               "src": "https://cdn.jwplayer.com/v2/media/SgKzo48g/poster.jpg?width=320",
               "width": 320,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/SgKzo48g/poster.jpg?width=480",
               "width": 480,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/SgKzo48g/poster.jpg?width=640",
               "width": 640,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/SgKzo48g/poster.jpg?width=720",
               "width": 720,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/SgKzo48g/poster.jpg?width=1280",
               "width": 1280,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/SgKzo48g/poster.jpg?width=1920",
               "width": 1920,
               "type": "image/jpeg"
            }
         ],
         "feedid": "d7sk9orq",
         "duration": 10,
         "pubdate": 1656014836,
         "description": "",
         "tags": "feedtableview,bpa,ios",
         "sources": [
            {
               "file": "https://cdn.jwplayer.com/manifests/SgKzo48g.m3u8",
               "type": "application/vnd.apple.mpegurl"
            },
            {
               "file": "https://cdn.jwplayer.com/videos/SgKzo48g-v713jOfL.mp4",
               "type": "video/mp4",
               "height": 180,
               "width": 320,
               "label": "180p",
               "bitrate": 451149,
               "filesize": 563937,
               "framerate": 25
            },
            {
               "file": "https://cdn.jwplayer.com/videos/SgKzo48g-1HebiUkE.mp4",
               "type": "video/mp4",
               "height": 270,
               "width": 480,
               "label": "270p",
               "bitrate": 656722,
               "filesize": 820903,
               "framerate": 25
            }
         ],
         "tracks": [
            {
               "file": "https://cdn.jwplayer.com/strips/SgKzo48g-120.vtt",
               "kind": "thumbnails"
            }
         ],
         "variations": {}
      },
      {
         "title": "Stock-footage-nature-river-waterfall-forest-sun-morning-magical",
         "mediaid": "A95GxtFI",
         "link": "https://cdn.jwplayer.com/previews/A95GxtFI",
         "image": "https://cdn.jwplayer.com/v2/media/A95GxtFI/poster.jpg?width=720",
         "images": [
            {
               "src": "https://cdn.jwplayer.com/v2/media/A95GxtFI/poster.jpg?width=320",
               "width": 320,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/A95GxtFI/poster.jpg?width=480",
               "width": 480,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/A95GxtFI/poster.jpg?width=640",
               "width": 640,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/A95GxtFI/poster.jpg?width=720",
               "width": 720,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/A95GxtFI/poster.jpg?width=1280",
               "width": 1280,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/A95GxtFI/poster.jpg?width=1920",
               "width": 1920,
               "type": "image/jpeg"
            }
         ],
         "feedid": "d7sk9orq",
         "duration": 29,
         "pubdate": 1656014702,
         "description": "",
         "tags": "feedtableview,bpa,ios",
         "sources": [
            {
               "file": "https://cdn.jwplayer.com/manifests/A95GxtFI.m3u8",
               "type": "application/vnd.apple.mpegurl"
            },
            {
               "file": "https://cdn.jwplayer.com/videos/A95GxtFI-v713jOfL.mp4",
               "type": "video/mp4",
               "height": 180,
               "width": 320,
               "label": "180p",
               "bitrate": 442772,
               "filesize": 1605049,
               "framerate": 30
            },
            {
               "file": "https://cdn.jwplayer.com/videos/A95GxtFI-1HebiUkE.mp4",
               "type": "video/mp4",
               "height": 270,
               "width": 480,
               "label": "270p",
               "bitrate": 643146,
               "filesize": 2331407,
               "framerate": 30
            }
         ],
         "tracks": [
            {
               "file": "https://cdn.jwplayer.com/strips/A95GxtFI-120.vtt",
               "kind": "thumbnails"
            }
         ],
         "variations": {}
      },
      {
         "title": "Stock-footage-people-in-the-park-happy-family-silhouette-walk-at-sunset-mom-dad-and-daughters-walk-holding",
         "mediaid": "lNjekeid",
         "link": "https://cdn.jwplayer.com/previews/lNjekeid",
         "image": "https://cdn.jwplayer.com/v2/media/lNjekeid/poster.jpg?width=720",
         "images": [
            {
               "src": "https://cdn.jwplayer.com/v2/media/lNjekeid/poster.jpg?width=320",
               "width": 320,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/lNjekeid/poster.jpg?width=480",
               "width": 480,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/lNjekeid/poster.jpg?width=640",
               "width": 640,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/lNjekeid/poster.jpg?width=720",
               "width": 720,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/lNjekeid/poster.jpg?width=1280",
               "width": 1280,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/lNjekeid/poster.jpg?width=1920",
               "width": 1920,
               "type": "image/jpeg"
            }
         ],
         "feedid": "d7sk9orq",
         "duration": 22,
         "pubdate": 1656014523,
         "description": "",
         "tags": "feedtableview,bpa,ios",
         "sources": [
            {
               "file": "https://cdn.jwplayer.com/manifests/lNjekeid.m3u8",
               "type": "application/vnd.apple.mpegurl"
            },
            {
               "file": "https://cdn.jwplayer.com/videos/lNjekeid-v713jOfL.mp4",
               "type": "video/mp4",
               "height": 180,
               "width": 320,
               "label": "180p",
               "bitrate": 324970,
               "filesize": 893668,
               "framerate": 25
            },
            {
               "file": "https://cdn.jwplayer.com/videos/lNjekeid-1HebiUkE.mp4",
               "type": "video/mp4",
               "height": 270,
               "width": 480,
               "label": "270p",
               "bitrate": 580501,
               "filesize": 1596380,
               "framerate": 25
            }
         ],
         "tracks": [
            {
               "file": "https://cdn.jwplayer.com/strips/lNjekeid-120.vtt",
               "kind": "thumbnails"
            }
         ],
         "variations": {}
      },
      {
         "title": "190915 B 01 Timelapse Danang 05",
         "mediaid": "KLwWokqk",
         "link": "https://cdn.jwplayer.com/previews/KLwWokqk",
         "image": "https://cdn.jwplayer.com/v2/media/KLwWokqk/poster.jpg?width=720",
         "images": [
            {
               "src": "https://cdn.jwplayer.com/v2/media/KLwWokqk/poster.jpg?width=320",
               "width": 320,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/KLwWokqk/poster.jpg?width=480",
               "width": 480,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/KLwWokqk/poster.jpg?width=640",
               "width": 640,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/KLwWokqk/poster.jpg?width=720",
               "width": 720,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/KLwWokqk/poster.jpg?width=1280",
               "width": 1280,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/KLwWokqk/poster.jpg?width=1920",
               "width": 1920,
               "type": "image/jpeg"
            }
         ],
         "feedid": "d7sk9orq",
         "duration": 12,
         "pubdate": 1656014632,
         "description": "",
         "tags": "feedtableview,bpa,ios",
         "sources": [
            {
               "file": "https://cdn.jwplayer.com/manifests/KLwWokqk.m3u8",
               "type": "application/vnd.apple.mpegurl"
            },
            {
               "file": "https://cdn.jwplayer.com/videos/KLwWokqk-v713jOfL.mp4",
               "type": "video/mp4",
               "height": 180,
               "width": 320,
               "label": "180p",
               "bitrate": 351948,
               "filesize": 527922,
               "framerate": 30
            },
            {
               "file": "https://cdn.jwplayer.com/videos/KLwWokqk-1HebiUkE.mp4",
               "type": "video/mp4",
               "height": 270,
               "width": 480,
               "label": "270p",
               "bitrate": 550639,
               "filesize": 825959,
               "framerate": 30
            },
            {
               "file": "https://cdn.jwplayer.com/videos/KLwWokqk-r3Dj1xfK.mp4",
               "type": "video/mp4",
               "height": 406,
               "width": 720,
               "label": "406p",
               "bitrate": 677925,
               "filesize": 1016888,
               "framerate": 30
            },
            {
               "file": "https://cdn.jwplayer.com/videos/KLwWokqk-hCkQHtVz.mp4",
               "type": "video/mp4",
               "height": 720,
               "width": 1280,
               "label": "720p",
               "bitrate": 1481936,
               "filesize": 2222904,
               "framerate": 30
            },
            {
               "file": "https://cdn.jwplayer.com/videos/KLwWokqk-J0W48ONu.m4a",
               "type": "audio/mp4",
               "label": "AAC Audio",
               "bitrate": 116332,
               "filesize": 174499
            },
            {
               "file": "https://cdn.jwplayer.com/videos/KLwWokqk-Yi2Ea3eE.mp4",
               "type": "video/mp4",
               "height": 1080,
               "width": 1920,
               "label": "1080p",
               "bitrate": 2929777,
               "filesize": 4394666,
               "framerate": 30
            }
         ],
         "tracks": [
            {
               "file": "https://cdn.jwplayer.com/strips/KLwWokqk-120.vtt",
               "kind": "thumbnails"
            }
         ],
         "variations": {}
      },
      {
         "title": "Sintel - 52sec",
         "mediaid": "hysZAKhf",
         "link": "https://cdn.jwplayer.com/previews/hysZAKhf",
         "image": "https://cdn.jwplayer.com/v2/media/hysZAKhf/poster.jpg?width=720",
         "images": [
            {
               "src": "https://cdn.jwplayer.com/v2/media/hysZAKhf/poster.jpg?width=320",
               "width": 320,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/hysZAKhf/poster.jpg?width=480",
               "width": 480,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/hysZAKhf/poster.jpg?width=640",
               "width": 640,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/hysZAKhf/poster.jpg?width=720",
               "width": 720,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/hysZAKhf/poster.jpg?width=1280",
               "width": 1280,
               "type": "image/jpeg"
            },
            {
               "src": "https://cdn.jwplayer.com/v2/media/hysZAKhf/poster.jpg?width=1920",
               "width": 1920,
               "type": "image/jpeg"
            }
         ],
         "feedid": "d7sk9orq",
         "duration": 52,
         "pubdate": 1656013013,
         "description": "",
         "tags": "feedtableview,bpa,ios,sintel",
         "sources": [
            {
               "file": "https://cdn.jwplayer.com/manifests/hysZAKhf.m3u8",
               "type": "application/vnd.apple.mpegurl"
            },
            {
               "file": "https://cdn.jwplayer.com/videos/hysZAKhf-v713jOfL.mp4",
               "type": "video/mp4",
               "height": 136,
               "width": 320,
               "label": "180p",
               "bitrate": 269117,
               "filesize": 1749265,
               "framerate": 24
            },
            {
               "file": "https://cdn.jwplayer.com/videos/hysZAKhf-J0W48ONu.m4a",
               "type": "audio/mp4",
               "label": "AAC Audio",
               "bitrate": 116086,
               "filesize": 754563
            }
         ],
         "tracks": [
            {
               "file": "https://cdn.jwplayer.com/strips/hysZAKhf-120.vtt",
               "kind": "thumbnails"
            }
         ],
         "variations": {}
      }
   ],
   "feed_instance_id": "21940332-af6e-4eab-a946-aefb18bce30a"
}
"""
