//
//  ProfileManager.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 03.03.26.
//

import Foundation


class ProfileManager:ProfileUseCase {
    
    private var manager: CoreManager
    init(manager: CoreManager) {
        self.manager = manager
    }
        
    func getCurrentUserProfile(completion: @escaping (UserProfile?, String?) -> Void) {
//        tokenManager.checkAccessToken(model: UserProfile.self, endpoint: Endpoint.UserProfile.url, completion: completion)
        manager.request(model: UserProfile.self, endpoint: Endpoint.UserProfile.url, completion: completion,needAuth: true)
    }
    
}
