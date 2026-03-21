//
//  AlbumDetailResponse.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 21.03.26.
//

import Foundation

struct AlbumDetailResponse: Codable {
    let id: String
    let name: String
    let images: [SpotifyImage]
    let artists: [Artist]
    let albumType: String
    let releaseDate: String
    let tracks: AlbumTracksResponse
    
    enum CodingKeys: String, CodingKey {
        case id, name, images, artists, tracks
        case albumType = "album_type"
        case releaseDate = "release_date"
    }
}

struct AlbumTracksResponse: Codable {
    let items: [AlbumTrack]
}

struct AlbumTrack: Codable {
    let id: String
    let name: String
    let artists: [Artist]
    let durationMs: Int
    let uri: String
    let trackNumber: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, artists, uri
        case durationMs = "duration_ms"
        case trackNumber = "track_number"
    }
}
