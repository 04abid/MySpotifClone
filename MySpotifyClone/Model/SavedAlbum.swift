//
//  SavedAlbum.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 04.03.26.
//

import Foundation


struct SavedAlbumsResponse: Codable {
    let items: [SavedAlbumItem]
    let next: String?
    let limit: Int
    let total: Int
}

struct SavedAlbumItem: Codable {
    let addedAt: String
    let album: Album
    
    enum CodingKeys: String, CodingKey {
        case addedAt = "added_at"
        case album
    }
}
