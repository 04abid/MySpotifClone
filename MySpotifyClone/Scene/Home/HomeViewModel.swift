//
//  HomeViewModel.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 24.02.26.
//

import Foundation


class HomeViewModel {
    
    var recentlyPlayed: [RecentlyPlayedItem] = []
    var savedAlbums: [SavedAlbumItem] = []
    var topTracks: [Track] = []
    
    private let manager: HomeUseCase
    init(manager: HomeUseCase) {
        self.manager = manager
    }
    
    var succes: (() -> Void)?
    var error: ((String) -> Void)?
    
    func getBrowseData() {
        manager.getHomeData { recentData, savedAlbumData, topTrackData in
            self.recentlyPlayed = recentData?.items ?? []
            self.savedAlbums = savedAlbumData?.items ?? []
            self.topTracks = topTrackData?.items ?? []
            self.succes?()
        }
    }
}
