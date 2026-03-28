//
//  SearchManager.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 24.03.26.
//

import Foundation

class SearchManager: SearchUseCase {
    func getSearchInformations(word: String, completion: @escaping (Search?, String?) -> Void) {
        TokenRefreshManager.shared.checkAccessToken(model: Search.self, endpoint: Endpoint.search(word: word).url, completion: completion)
    }
}
