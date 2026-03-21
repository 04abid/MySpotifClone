//
//  AuthenticatedRequestManager.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 05.03.26.
//

import Foundation


class TokenRefreshManager {
    static let shared = TokenRefreshManager()
    private let manager = CoreManager()
    private let tokenProvider =  KeychainManager.shared
    private let authManager = AuthManager.shared
    
   private  init() {}
    
    func checkAccessToken<T:Codable>(model:T.Type,endpoint:String?,completion: @escaping((T?,String?) -> Void)) {
        authManager.refreshAccessToken { succes in
            guard succes else {
                print("token yenilenmedi")
                return
            }
            
            
            guard let accessToken = self.tokenProvider.accesToken else {
                completion(nil, "Token Yoxdur")
                return
            }
            
            
            let headers: [String: String] = [
                "Authorization": "Bearer \(accessToken)"
            ]
            
            //        print("TOKEN: \(accessToken)")
            //        print("ENDPOINT: \(Endpoint.UserProfile.url)")
            
            self.manager.request(model: T.self,
                            method: "GET",
                            headers: headers,
                            endpoint: endpoint ?? "",
                            completion: completion)
            
        }
    }
}
