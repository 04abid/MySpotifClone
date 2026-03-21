//
//  Endpoint.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 28.02.26.
//

import Foundation


enum Endpoint {
    case featuredPlaylists
    case newReleases
    case recommendations
    case recentlyPlayed
    case exchangeToken
    case UserProfile
    case Browse
    case savedAlbums
    case topTracks
    case albumDetail(id: String)
    
    var url: String {
        let base = "https://api.spotify.com/v1"
        switch self {
        case .featuredPlaylists: return "\(base)/browse/featured-playlists"
        case .newReleases:       return "\(base)/browse/new-releases"
        case .recommendations:   return "\(base)/recommendations"
        case .recentlyPlayed:    return "\(base)/me/player/recently-played?limit=10"
        case .exchangeToken:     return "https://accounts.spotify.com/api/token"
        case .UserProfile:       return "\(base)/me"
        case .Browse:            return "\(base)/me/shows?offset=0&limit=20"
        case .savedAlbums:       return "\(base)/me/albums?limit=10"
        case .topTracks:         return "\(base)/me/top/tracks?limit=10"
        case .albumDetail(let id): return "\(base)/albums/\(id)"
        }
    }
}
