//
//  ProfileManager.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 03.03.26.
//

import Foundation


class ProfileManager:ProfileUseCase {
    
    private var tokenManager: TokenRefreshManager
    init(tokenManager: TokenRefreshManager) {
        self.tokenManager = tokenManager
    }
        
    func getCurrentUserProfile(completion: @escaping (UserProfile?, String?) -> Void) {
        tokenManager.checkAccessToken(model: UserProfile.self, endpoint: Endpoint.UserProfile.url, completion: completion)
    }
}
