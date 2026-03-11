//
//  Authmanager.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 26.02.26.
//

import Foundation


class AuthManager:AuthUseCase {
    
    let manager: CoreManager
    private let keychain = KeychainManager()
    
    init(manager: CoreManager) {
        self.manager = manager
    }
    

    private struct Constants {
        static let clientID = "541c65d55d514f81a5c0913b1094aaa2"
        static let clientSecret = "62e203140ad2459089ed2341f16d94cf"
        static let redirectURI = "spotify-ios-quick-start://spotify-login-callback"
        static let tokenApiURl = "https://accounts.spotify.com/api/token"
        static let scopes: String = [
            "user-read-private",
            "user-read-email",
            "playlist-read-private",
            "playlist-read-collaborative",
            "user-top-read",
            "user-read-recently-played",
            "user-library-read",
            "user-read-playback-state",
            "user-modify-playback-state",
            "streaming"
        ].joined(separator: "%20")
    }
    
    public var signInURL: URL? {
        let body = "https://accounts.spotify.com/authorize"
        let urlString = "\(body)" +
            "?response_type=code" +
            "&client_id=\(Constants.clientID)" +
            "&scope=\(Constants.scopes)" +
            "&redirect_uri=\(Constants.redirectURI)" +
            "&show_dialog=true"
        
        return URL(string: urlString)
    }
    
    var isSignedIn: Bool {
        return keychain.get(forKey: "access_token") != nil
    }
    
    private var accessToken: String? {
        return keychain.get(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return keychain.get(forKey: "refresh_token")
    }
    
    private var tokenExparationDate: Date? {
        return UserDefaults.standard.object(forKey: "expires_in") as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let exparationDate = tokenExparationDate else {
            return false
        }
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMinutes) >= exparationDate
    }

    public var authorizationHeader: String {
        let token = "\(Constants.clientID):\(Constants.clientSecret)"
        return "Basic \(Data(token.utf8).base64EncodedString())"
    }
}


// MARK: Functions

extension AuthManager {
    func exchangeCodeForToken(code: String, completion: @escaping (AuthResponse?, String?) -> Void) {
        
        let parameters: [String:Any] = [
            "grant_type"  : "authorization_code",
            "code"        : code,
            "redirect_uri": Constants.redirectURI]
        
        let headers: [String:String] = [
            "Authorization": authorizationHeader,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        
        manager.request(model: AuthResponse.self,
                        method: "POST",
                        parameters: parameters,
                        headers:headers,
                        endpoint: Constants.tokenApiURl,
                        completion: completion)
    }
    
    func cacheToken(result: AuthResponse) {
        if let accessToken = result.accessToken {
            keychain.save(accessToken, forKey:"access_token")
        }
        
        if let refreshToken = result.refreshToken {
            keychain.save(refreshToken, forKey: "refresh_token")
        }
        
        let exparationDate = Date().addingTimeInterval(TimeInterval(result.expiresIn ?? 0))
        UserDefaults.standard.set(exparationDate, forKey: "expires_in")
        print("TOKEN BİTMƏ TARİXİ: \(exparationDate)")
        print("HAL-HAZIRKI VAXT: \(Date())")
    }
    
    func refreshAccessToken(completion: @escaping (Bool) -> Void) {
        print("shouldRefreshToken: \(shouldRefreshToken)")
        print("tokenExparationDate: \(String(describing: tokenExparationDate))")
        print("HAL-HAZIRKI VAXT: \(Date())")
        
        guard shouldRefreshToken else {
            completion(true)
            return
        }
        
        guard let refreshToken = self.refreshToken else {
            completion(false)
            return
        }
        
        let parameters: [String: Any] = [
            "grant_type"   : "refresh_token",
            "refresh_token": refreshToken
        ]
        
        let headers: [String: String] = [
            "Authorization": authorizationHeader,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        
        manager.request(model: AuthResponse.self,
                        method: "POST",
                        parameters: parameters,
                        headers: headers,
                        endpoint: Constants.tokenApiURl) { [weak self] result, error in
            if let result = result {
                self?.cacheToken(result: result)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
