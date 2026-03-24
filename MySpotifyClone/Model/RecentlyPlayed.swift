//
//  RecentlyPlayed.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 04.03.26.
//

import Foundation


struct RecentlyPlayedResponse: Codable {
    let items: [RecentlyPlayedItem]
    let next: String?
    let limit: Int
}

struct RecentlyPlayedItem: Codable {
    let track: Track
    let playedAt: String
    
    enum CodingKeys: String, CodingKey {
        case track
        case playedAt = "played_at"
    }
}


struct Track: Codable {
    let id: String
    let name: String
    let artists: [Artist]
    let album: Album?
    let durationMs: Int
    let explicit: Bool?
    let uri: String
    let isPlayable: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, name, artists, album, uri, explicit
        case durationMs = "duration_ms"
        case isPlayable = "is_playable"
    }
}


struct Album: Codable {
    let id: String
    let name: String
    let images: [SpotifyImage]
    let artists: [Artist]
    let albumType: String
    let releaseDate: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, images, artists
        case albumType = "album_type"
        case releaseDate = "release_date"
    }
}


struct Artist: Codable {
    let id: String
    let name: String
}


struct SpotifyImage: Codable {
    let url: String
    let height: Int?
    let width: Int?
}
