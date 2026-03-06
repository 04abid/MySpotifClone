//
//  HomeUseCase.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 28.02.26.
//

import Foundation


protocol HomeUseCase {
    func getHomeData(completion:@escaping((RecentlyPlayedResponse?,SavedAlbumsResponse?,TopTracksResponse?) -> Void))
}
