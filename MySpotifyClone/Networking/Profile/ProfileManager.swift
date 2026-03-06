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
    
    
//    private let manager: CoreManager
//    private let tokenProvider: TokenProviding
//    private let authManager: AuthUseCase
//    
//    init(manager: CoreManager, tokenProvider: TokenProviding, authManager: AuthUseCase) {
//        self.manager = manager
//        self.tokenProvider = tokenProvider
//        self.authManager = authManager
//    }
//    
//    func getCurrentUserProfile(completion: @escaping((UserProfile?,String?) -> Void)) {
//        authManager.refreshAccessToken { succes in
//            guard succes else {
//                print("token yenilenmedi")
//                return
//            }
//        }
//        
//        guard let accessToken = tokenProvider.accesToken else {
//            completion(nil, "Token Yoxdur")
//            return
//        }
//    
//        
//        let headers: [String: String] = [
//            "Authorization": "Bearer \(accessToken)"
//        ]
//        
////        print("TOKEN: \(accessToken)")
////        print("ENDPOINT: \(Endpoint.UserProfile.url)")
//        
//        manager.request(model: UserProfile.self,
//                        method: "GET",
//                        headers: headers,
//                        endpoint: Endpoint.UserProfile.url,
//                        completion: completion)
//        
//    }
}
