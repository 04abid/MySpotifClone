//
//  AlbumUseCase.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 21.03.26.
//

import Foundation


protocol AlbumUseCase {
    func getAlbumData(albumID: String,completion: @escaping (AlbumDetailResponse?,String?) -> Void) 
}
