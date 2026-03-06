//
//  PlayerViewModel.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 06.03.26.
//

import Foundation

class PlayerViewModel {
    let track: Track
    
    init(track: Track) {
        self.track = track
    }
    
    var trackName: String {
        return track.name
    }
    
    var artistName: String {
        return track.artists.first?.name ?? ""
    }
    
    var imageURL: String {
        return track.album.images.first?.url ?? ""
    }
    
    var albumName: String {
        return track.album.name
    }
    
    var duration: Int {
        return track.durationMs / 1000  // saniyəyə çevir
    }
   
}
