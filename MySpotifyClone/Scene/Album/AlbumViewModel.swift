//
//  AlbumViewModel.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 06.03.26.
//

import Foundation


class AlbumViewModel {
    
    var album: Album
    var albumDetail: [AlbumTrack] = []
    var succes: (() -> Void)?
    var error: ((String) -> Void)?
    
    private let manager: AlbumUseCase
    init(manager: AlbumUseCase,album: Album) {
        self.manager = manager
        self.album = album
    }
    
    func getAlbumDetail() {
        manager.getAlbumData(albumID: album.id) { result, errorMessage in
            if let errorMessage {
                self.error?(errorMessage)
            } else if let result = result {
                self.albumDetail = result.tracks.items
                self.succes?()
            }
        }
    }
}
