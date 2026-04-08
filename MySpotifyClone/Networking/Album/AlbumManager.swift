//
//  AlbumManager.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 21.03.26.
//

import Foundation

class AlbumManager: AlbumUseCase {
    
    let manager: CoreManager
    init(manager: CoreManager) {
        self.manager = manager
    }
    
    func getAlbumData(albumID: String, completion: @escaping (AlbumDetailResponse?,String?) -> Void) {
        manager.request(model: AlbumDetailResponse.self, endpoint: Endpoint.albumDetail(id:albumID).url, completion: completion,needAuth: true)
    }
}
