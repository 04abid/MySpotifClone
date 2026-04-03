//
//  Search.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 24.03.26.
//

import Foundation

protocol ReusableSearch {
    var musicName: String { get }
    var musicImage: String { get }
}

struct Search: Codable {
    let searchTracks: SearchTracks?
    let searchArtists: SearchArtists?
    let searchAlbums: SearchAlbums?
    
    enum CodingKeys: String, CodingKey {
        case searchTracks = "tracks"
        case searchArtists = "artists"
        case searchAlbums = "albums"
    }
}

struct SearchTracks: Codable {
    let items: [Track]
}

struct SearchArtists: Codable {
    let items: [Artist]
}

struct SearchAlbums: Codable {
    let items: [Album]
}

// MARK: - ReusableSearch Protocol 
extension Track: ReusableSearch {
    var musicName: String {
        return name
    }
    
    var musicImage: String {
        return album?.images.first?.url ?? ""
    }
}

extension Artist: ReusableSearch {
    var musicName: String {
        return name
    }
    
    var musicImage: String {
        return images?.first?.url ?? ""
    }
}

extension Album: ReusableSearch {
    var musicName: String {
        return name
    }
    
    var musicImage: String {
        return images.first?.url ?? ""
    }
}
