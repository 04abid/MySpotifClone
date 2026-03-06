//
//  HomeEnum.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 04.03.26.
//

import Foundation


enum HomeFilter: String,CaseIterable {
    case all = "All"
    case music = "Music"
    case podcast = "Podcast"
}

enum HomeSection: Int, CaseIterable {
    case recentlyPlayed
    case topTracks
    case savedAlbums
}

