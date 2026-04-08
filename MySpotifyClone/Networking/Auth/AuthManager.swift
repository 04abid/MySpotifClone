//
//  Authmanager.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 26.02.26.
//

import Foundation

class AuthManager:AuthUseCase {
    static let shared = AuthManager()
    private let manager =  CoreManager()
    private lazy var  fireStore = FireStoreManager()
    
    private init() {
        self.clientID = KeychainManager.shared.get(forKey: "clientID")
        self.clientSecret  = KeychainManager.shared.get(forKey: "clientSecret")
    }

    private struct Constants {
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
        "&client_id=\(self.clientID ?? "")" +
            "&scope=\(Constants.scopes)" +
            "&redirect_uri=\(Constants.redirectURI)" +
            "&show_dialog=true"
        
        return URL(string: urlString)
    }
    
    private var clientID: String? = nil
    private var clientSecret: String? = nil
        
    
    
    var isSignedIn: Bool {
        return KeychainManager.shared.get(forKey: "access_token") != nil
    }
    
    private var accessToken: String? {
        return KeychainManager.shared.get(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return KeychainManager.shared.get(forKey: "refresh_token")
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
        let token = "\(self.clientID ?? ""):\(self.clientSecret ?? "")"
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
            KeychainManager.shared.save(accessToken, forKey:"access_token")
        }
        
        if let refreshToken = result.refreshToken {
            KeychainManager.shared.save(refreshToken, forKey: "refresh_token")
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
    
          func loadCredentials(completion:@escaping((Bool) -> Void)) {
        fireStore.getDataFromFireBase { [weak self] clientID, clientSecret in
            if let ID = clientID,let secret = clientSecret {
                self?.clientID = ID
                self?.clientSecret = secret
                KeychainManager.shared.save(ID, forKey: "clientID")
                KeychainManager.shared.save(secret, forKey: "clientSecret")
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func signOut() {
        KeychainManager.shared.delete(forKey: "access_token")
        KeychainManager.shared.delete(forKey: "refresh_token")
        UserDefaults.standard.removeObject(forKey: "expires_in")
    }
    
}
