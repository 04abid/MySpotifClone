//
//  AlbumManager.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 21.03.26.
//

import Foundation

class AlbumManager: AlbumUseCase {
    func getAlbumData(albumID: String, completion: @escaping (AlbumDetailResponse?,String?) -> Void) {
        TokenRefreshManager.shared.checkAccessToken(model: AlbumDetailResponse.self, endpoint: Endpoint.albumDetail(id:albumID).url, completion: completion)
    }
}
