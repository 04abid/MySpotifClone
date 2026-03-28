//
//  Search.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 24.03.26.
//

import Foundation

struct Search: Codable {
    let tracks: SearchTracks?
    let artists: SearchArtists?
    let albums: SearchAlbums?
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
