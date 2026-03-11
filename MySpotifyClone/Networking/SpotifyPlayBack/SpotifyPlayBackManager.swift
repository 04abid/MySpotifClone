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
    
    // SDK callback (köhnə - saxlayırıq)
    var onPlayerStateChanged: ((SPTAppRemotePlayerState) -> Void)?
    
    // Yeni wrapper callback-lər (SDK tipləri olmadan)
    var onStateChanged: ((Bool, String, String, Int, Int) -> Void)?
    var onImageReady: ((UIImage?) -> Void)?
    
    lazy var appRemote: SPTAppRemote = {
        let config = SPTConfiguration(
            clientID: "541c65d55d514f81a5c0913b1094aaa2",
            redirectURL: URL(string: "spotify-ios-quick-start://spotify-login-callback")!
        )
        let appRemote = SPTAppRemote(configuration: config, logLevel: .debug)
        appRemote.delegate = self
        return appRemote
    }()
    
    var isConnected: Bool {
        return appRemote.isConnected
    }
    
    func connect() {
        let token = KeychainManager.shared.get(forKey: "spotify_remote_token")
                    ?? KeychainManager.shared.accesToken
        print(">>> CONNECT - token: \(token ?? "NIL")")
        guard let token = token else { return }
        appRemote.connectionParameters.accessToken = token
        appRemote.connect()
    }
    
    func play(uri: String) {
        appRemote.playerAPI?.play(uri) { _, error in
            if let error = error {
                print("Play xəta: \(error)")
            }
        }
    }
    
    func pause() {
        appRemote.playerAPI?.pause(nil)
    }
    
    func resume() {
        appRemote.playerAPI?.resume(nil)
    }
    
    func skipToNext() {
        appRemote.playerAPI?.skip(toNext: nil)
    }
    
    func skipToPrevious() {
        appRemote.playerAPI?.skip(toPrevious: nil)
    }
    
    func setShuffle(enabled: Bool) {
        appRemote.playerAPI?.setShuffle(enabled) { _, error in
            if let error = error {
                print("Shuffle xəta: \(error)")
            }
        }
    }
    
    func setRepeatMode(mode: Int) {
        let repeatMode: SPTAppRemotePlaybackOptionsRepeatMode
        switch mode {
        case 0:
            repeatMode = .off
        case 1:
            repeatMode = .context
        case 2:
            repeatMode = .track
        default:
            return
        }
        appRemote.playerAPI?.setRepeatMode(repeatMode) { _, error in
            if let error = error {
                print("Repeat xəta: \(error)")
            }
        }
    }
    
    func seek(to position: Int) {
        appRemote.playerAPI?.seek(toPosition: position) { _, error in
            if let error = error {
                print("Seek xəta: \(error)")
            }
        }
    }
    
    func fetchImage(for track: SPTAppRemoteTrack, size: CGSize = CGSize(width: 300, height: 300), completion: @escaping (UIImage?) -> Void) {
        appRemote.imageAPI?.fetchImage(forItem: track, with: size) { image, error in
            if let error = error {
                print("Image fetch xəta: \(error)")
                completion(nil)
            } else if let image = image as? UIImage {
                completion(image)
                NotificationCenter.default.post(name: .playerImageDidChange, object: nil, userInfo: [
                    "image": image
                ])
            }
        }
    }
    
    func getPlayerState(completion: @escaping (Bool, Int, Int, Bool) -> Void) {
        appRemote.playerAPI?.getPlayerState { result, error in
            if let state = result as? SPTAppRemotePlayerState {
                let options = state.playbackOptions
                var repeatValue = 0
                if options.repeatMode == .track {
                    repeatValue = 2
                } else if options.repeatMode == .context {
                    repeatValue = 1
                }
                completion(options.isShuffling, repeatValue, Int(state.playbackPosition), state.isPaused)
            }
        }
    }
    
    func authorize(uri: String) {
        appRemote.authorizeAndPlayURI(uri)
    }
}

extension SpotifyPlayBackManager: SPTAppRemoteDelegate {
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        print("Spotify-a bağlandı!")
        appRemote.playerAPI?.delegate = self
        appRemote.playerAPI?.subscribe(toPlayerState: nil)
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("Bağlantı uğursuz: \(error?.localizedDescription ?? "")")
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("Bağlantı kəsildi: \(error?.localizedDescription ?? "")")
    }
}

extension SpotifyPlayBackManager: SPTAppRemotePlayerStateDelegate {
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        onPlayerStateChanged?(playerState)
        
        onStateChanged?(
            playerState.isPaused,
            playerState.track.name,
            playerState.track.artist.name,
            Int(playerState.playbackPosition),
            Int(playerState.track.duration)
        )
        
        fetchImage(for: playerState.track) { [weak self] image in
            self?.onImageReady?(image)
        }
        
        NotificationCenter.default.post(name:.playerStateDidChange, object: nil, userInfo: [
            "isPaused": playerState.isPaused,
            "trackName": playerState.track.name,
            "artistName": playerState.track.artist.name,
            "position": Int(playerState.playbackPosition),
            "duration": Int(playerState.track.duration)
            
        ])
    }
}
