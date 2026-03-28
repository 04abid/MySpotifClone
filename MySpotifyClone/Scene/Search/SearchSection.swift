//
//  SearchSection.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 28.03.26.
//

import Foundation


enum SearchSection: Int, CaseIterable {
    case tracks = 0
    case artists = 1
    case albums = 2
    
    var title: String {
        switch self {
        case .tracks: return "Track"
        case .albums: return "Album"
        case .artists: return "Artist"
        }
    }
}
