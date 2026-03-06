//
//  TopTracks.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 04.03.26.
//

import Foundation


struct TopTracksResponse: Codable {
    let items: [Track]
    let next: String?
    let limit: Int
    let total: Int
}
