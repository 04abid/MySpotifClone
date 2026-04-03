//
//  FavoritesManager.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 02.04.26.
//

import Foundation


class FavoritesManager {
    static let shared = FavoritesManager()
    private let manager = FireStoreManager()
    private init() {}
    
    var likedMusics: [Track] = []
    var error: ((String)-> Void)?
    var succes:(() -> Void)?
    
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
            manager.deleteDataFromFireBase(model: music)
        } else {
            addTrack(music: music)
            manager.saveDataToFireBase(model: music)
        }
        NotificationCenter.default.post(name: .favoritesDidChange, object: nil)
    }
    
    func fetchData() {
        manager.fetchDataFromFireBase{ [weak self] track, errorMessage in
            if let errorMessage {
                self?.error?(errorMessage)
            } else if let track {
                self?.likedMusics = track
                self?.succes?()
            }
        }
    }
}


