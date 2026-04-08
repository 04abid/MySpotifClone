//
//  SearchManager.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 24.03.26.
//

import Foundation

class SearchManager: SearchUseCase {
    
    let manager: CoreManager
    init(manager: CoreManager) {
        self.manager = manager
    }
    
    func getSearchInformations(word: String, completion: @escaping (Search?, String?) -> Void) {
        manager.request(model: Search.self,
                        endpoint: Endpoint.search(word: word).url,
                        completion: completion,needAuth: true)
    }
}
