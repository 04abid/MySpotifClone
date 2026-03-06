//
//  SpotifyPlayBack.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 06.03.26.
//
import SpotifyiOS
import Foundation

class SpotifyPlayBackManager: NSObject {
    static let shared = SpotifyPlayBackManager()
    
    lazy var appRemote: SPTAppRemote = {
        let config = SPTConfiguration(
            clientID: "541c65d55d514f81a5c0913b1094aaa2",
            redirectURL: URL(string: "spotify-ios-quick-start://spotify-login-callback")!
        )
        let appRemote = SPTAppRemote(configuration: config, logLevel: .debug)
        appRemote.delegate = self
        return appRemote
    }()
    
    func connect() {
        guard let token = KeychainManager.shared.accesToken else {
            return
        }
        appRemote.connectionParameters.accessToken = token
        appRemote.connect()
    }
    
    func play(uri: String) {
        appRemote.playerAPI?.play(uri) { result, error in
            if let error = error {
                print("Play xəta: \(error.localizedDescription)")
            } else {
                print("Çalınır: \(uri)")
            }
        }
    }
    
    func pause() {
        appRemote.playerAPI?.pause(nil)
    }
    
    func resume() {
        appRemote.playerAPI?.resume(nil)
    }
}

extension SpotifyPlayBackManager: SPTAppRemoteDelegate {
    @objc func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        print("Spotify-a bağlandı!")
        // burda player state-ə subscribe olacağıq
    }
    
    @objc func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("Bağlantı uğursuz: \(error?.localizedDescription ?? "")")
    }
    
    @objc func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("Bağlantı kəsildi: \(error?.localizedDescription ?? "")")
    }
}
