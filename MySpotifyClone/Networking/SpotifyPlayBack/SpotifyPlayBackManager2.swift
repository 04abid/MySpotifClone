//
//  SpotifyPlayBackManager2.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 14.03.26.
//


import SpotifyiOS
import UIKit

class SpotifyPlayBackManager2: NSObject, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {
    static let shared = SpotifyPlayBackManager2()
    private override init() {}
    
    var isConnected: Bool {
       appRemote.isConnected
   }
    
    private(set) var lastTrackName: String = ""
    private(set) var lastArtistName: String = ""
    private(set) var lastTrackURI: String = ""
    private(set) var lastTrackDuration: Int = 0
    private(set) var lastImage: UIImage?
    
    var onStateChanged: ((Bool,String,String,Int,Int) -> Void)?
    var onImageChanged:((UIImage?) -> Void)?
    
    private lazy var appRemote: SPTAppRemote = {
        let config = SPTConfiguration(clientID: KeychainManager.shared.get(forKey: "clientID" ) ?? "",
                                      redirectURL: URL(string:"spotify-ios-quick-start://spotify-login-callback")!)
        let appRemote = SPTAppRemote(configuration: config, logLevel: .debug)
        appRemote.delegate = self
        return appRemote
    }()
    
     func connect() {
        let token = KeychainManager.shared.get(forKey: "spotify_remote_token")
                    ?? KeychainManager.shared.accesToken
        guard let token = token else {
            return
        }
        appRemote.connectionParameters.accessToken = token
        appRemote.connect()
    }
    
    private func fetchImage(for track: SPTAppRemoteTrack,size: CGSize = CGSize(width: 300, height: 300)) {
        appRemote.imageAPI?.fetchImage(forItem: track, with: size) { image,error in
            if let error {
               print("image fetch xeta")
            } else if let image = image as? UIImage {
                self.lastImage = image
                self.onImageChanged?(image)
                NotificationCenter.default.post(name: .playerImageDidChange, object: nil, userInfo: [
                    "image": image
                ])
            }
        }
    }
}
extension SpotifyPlayBackManager2 {
    
    func play(uri: String) {
        appRemote.playerAPI?.play(uri, callback: nil)
    }
    
    func pause() {
        appRemote.playerAPI?.pause(nil)
    }
    
    func skipToNext() {
        appRemote.playerAPI?.skip(toNext: nil)
    }
    
    func skipToPrevious() {
        appRemote.playerAPI?.skip(toPrevious: nil)
    }
    
    func resume() {
        appRemote.playerAPI?.resume(nil)
    }
    
    func setShuffle(enabled: Bool) {
        appRemote.playerAPI?.setShuffle(enabled, callback: nil)
    }
    
    func setRepeatMode(mode: Int) {
        switch mode {
        case 0:
            appRemote.playerAPI?.setRepeatMode(.off, callback: nil)
            
        case 1:
            appRemote.playerAPI?.setRepeatMode(.context, callback: nil)
            
        case 2:
            appRemote.playerAPI?.setRepeatMode(.track, callback: nil)
        default:
            appRemote.playerAPI?.setRepeatMode(.off, callback: nil)
        }
        
    }
    
    func seek(to position: Int) {
        appRemote.playerAPI?.seek(toPosition:position , callback: nil)
    }
    
    func authorize(uri:String) {
        appRemote.authorizeAndPlayURI(uri)
    }
    
    func getPlayerState(completion:@escaping((Bool,Int,Int,Bool) -> Void)) {
        appRemote.playerAPI?.getPlayerState { result, error in
            if let error {
            } else if let result = result as? SPTAppRemotePlayerState {
                let options = result.playbackOptions
                var repeatValue = 0
                if options.repeatMode == .track{
                    repeatValue = 2
                }
                else if options.repeatMode == .context {
                    repeatValue = 1
                }
                completion(options.isShuffling,repeatValue,Int(result.playbackPosition),result.isPaused)
            }
        }
    }
}

extension SpotifyPlayBackManager2 {
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        appRemote.playerAPI?.delegate = self
        appRemote.playerAPI?.subscribe(toPlayerState: nil)
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: (any Error)?) {
        print("Bqlanti uqursuz oldu")
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: (any Error)?) {
        print("Bqlanti kesildi")
    }
    
    // MARK: SPTAppRemotePlayerStateDelegate
    
    func playerStateDidChange(_ playerState: any SPTAppRemotePlayerState) {
        lastTrackName = playerState.track.name
        lastArtistName = playerState.track.artist.name
        lastTrackURI = playerState.track.uri
        lastTrackDuration = Int(playerState.track.duration)
        
       onStateChanged?(playerState.isPaused,
                      playerState.track.name,
                      playerState.track.artist.name,
                      Int(playerState.playbackPosition),
                      Int(playerState.track.duration)
       )
        fetchImage(for: playerState.track)
        
        NotificationCenter.default.post(name: .playerStateDidChange, object: nil, userInfo: [
            "isPaused": playerState.isPaused,
            "trackName": playerState.track.name,
            "artistName": playerState.track.artist.name,
            "position": Int(playerState.playbackPosition),
            "duration": Int(playerState.track.duration),
            "trackURI": playerState.track.uri
        ])
    }
    
}
