//
//  FavoritesManager.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 02.04.26.
//

import Foundation


class FavoritesManager {
    static let shared = FavoritesManager()
    private init() {}
    
    var likedMusics: [Track] = []
    
    func addTrack(music: Track) {
        likedMusics.append(music)
    }
    
    func removeTrack(music: Track) {
        likedMusics.removeAll {$0.id == music.id}
    }
    
    func isLiked(music: Track) -> Bool {
        likedMusics.contains {$0.id == music.id}
    }
    
    func toggleLike(music:Track) {
        if isLiked(music: music) {
            removeTrack(music: music)
        } else {
            addTrack(music: music)
        }
        NotificationCenter.default.post(name: .favoritesDidChange, object: nil)
    }
    
}


