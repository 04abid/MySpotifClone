//
//  HomeManager.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 28.02.26.
//

import Foundation


final class HomeManager:HomeUseCase {
    
    private var manager: TokenRefreshManager
    init(manager: TokenRefreshManager) {
        self.manager = manager
    }
    
    private func getRecentlyPlayed(completion:@escaping((RecentlyPlayedResponse?,String?) -> Void)) {
        manager.checkAccessToken(model: RecentlyPlayedResponse.self, endpoint: Endpoint.recentlyPlayed.url, completion: completion)
    }
    private func getSavedAlbums(completion:@escaping((SavedAlbumsResponse?,String?) -> Void)) {
        manager.checkAccessToken(model: SavedAlbumsResponse.self, endpoint: Endpoint.savedAlbums.url, completion: completion)
    }
    private func getTopTracks(completion:@escaping((TopTracksResponse?,String?) -> Void)) {
        manager.checkAccessToken(model: TopTracksResponse.self, endpoint: Endpoint.topTracks.url, completion: completion)
    }
    
    func getHomeData(completion:@escaping((RecentlyPlayedResponse?,SavedAlbumsResponse?,TopTracksResponse?) -> Void)) {
        let group = DispatchGroup()
        
        var recentlyPlayed: RecentlyPlayedResponse?
        var savedAlbums: SavedAlbumsResponse?
        var topTracks: TopTracksResponse?
        
        group.enter()
        getRecentlyPlayed { result, _ in
            recentlyPlayed = result
            group.leave()
        }
        
        group.enter()
        getSavedAlbums { result, _ in
            savedAlbums = result
            group.leave()
        }
        
        group.enter()
        getTopTracks { result, _ in
            topTracks = result
            group.leave()
        }
        group.notify(queue: .main){
            completion(recentlyPlayed, savedAlbums, topTracks)
        }
    }
}
