//
//  PlayerViewModel.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 06.03.26.
//

import Foundation
import UIKit

class PlayerViewModel {
    // Track ola bilər nil — expand halında Track modelimiz yoxdur
    let track: Track?
    private let playerManager: SpotifyPlayBackManager
    
    // State
    private(set) var isPlaying = false
    private(set) var isShuffleOn = false
    private(set) var repeatCount = 0
    private var hasStartedPlaying = false
    private(set) var currentPosition: Int = 0
    private(set) var trackDuration: Int = 0
    private var timer: Timer?
    
    /// true = SDK-dan gələn state-ləri qəbul edirik
    /// false = play(uri:) hələ çağırılmayıb, ignore edirik
    private var isListeningToState = false
    
    // UI callback-lər
    var onPlayStateChanged: ((Bool) -> Void)?
    var onTrackChanged: ((String, String) -> Void)?
    var onImageChanged: ((UIImage?) -> Void)?
    var onProgressChanged: ((Float) -> Void)?
    var onTimeChanged: ((String, String) -> Void)?
    var onShuffleChanged: ((Bool) -> Void)?
    var onRepeatChanged: ((Int) -> Void)?
    var onGradientColorChanged: ((UIColor) -> Void)?
    var likeStateChanged: ((Bool) -> Void)?
    
    // Computed — expand halında PlaybackManager-dan oxuyur
    var trackName: String {
        track?.name ?? playerManager.lastTrackName
    }
    var artistName: String {
        track?.artists.first?.name ?? playerManager.lastArtistName
    }
    var imageURL: String {
        track?.album?.images.first?.url ?? ""
    }
    var albumName: String {
        track?.album?.name ?? ""
    }
    
    /// Expand halında PlaybackManager-dan son image-i qaytarır
    var currentImage: UIImage? {
        playerManager.lastImage
    }
    
    // MARK: - Init: yeni mahnıya click
    
    init(track: Track, playerManager: SpotifyPlayBackManager = .shared) {
        self.track = track
        self.playerManager = playerManager
        self.trackDuration = track.durationMs
        self.isListeningToState = false  // play basılana qədər ignore
        self.hasStartedPlaying = false
        setupListeners()
    }
    
    // MARK: - Init: mini player-dən expand (Track model yoxdur)
    
    init(playerManager: SpotifyPlayBackManager = .shared) {
        self.track = nil
        self.playerManager = playerManager
        self.trackDuration = playerManager.lastTrackDuration
        self.isListeningToState = true   // artıq oxuyur
        self.hasStartedPlaying = true    // resume etsin, play(uri:) yox
        setupListeners()
    }
    
    // MARK: - Listeners
    
    private func setupListeners() {
        playerManager.onStateChanged = { [weak self] isPaused, trackName, artistName, position, duration in
            guard let self = self, self.isListeningToState else { return }
            
            DispatchQueue.main.async {
                self.isPlaying = !isPaused
                self.currentPosition = position
                self.trackDuration = duration
                
                self.onPlayStateChanged?(!isPaused)
                self.onTrackChanged?(trackName, artistName)
                self.updateTimeLabels()
                
                if duration > 0 {
                    let progress = Float(position) / Float(duration)
                    self.onProgressChanged?(progress)
                }
                
                if !isPaused {
                    self.startTimer()
                } else {
                    self.timer?.invalidate()
                }
            }
        }
        
        playerManager.onImageReady = { [weak self] image in
            guard let self = self, self.isListeningToState else { return }
            DispatchQueue.main.async {
                self.onImageChanged?(image)
                if let color = image?.averageColor {
                    self.onGradientColorChanged?(color)
                }
            }
        }
    }
    
    // MARK: - Sync
    
    func syncPlayerState() {
        guard isListeningToState else { return }
        
        playerManager.getPlayerState { [weak self] isShuffling, repeatValue, position, isPaused in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isShuffleOn = isShuffling
                self.repeatCount = repeatValue
                self.currentPosition = position
                self.isPlaying = !isPaused
                
                self.onShuffleChanged?(isShuffling)
                self.onRepeatChanged?(repeatValue)
                self.onPlayStateChanged?(!isPaused)
                self.updateTimeLabels()
                
                if self.trackDuration > 0 {
                    let progress = Float(position) / Float(self.trackDuration)
                    self.onProgressChanged?(progress)
                }
                
                if !isPaused {
                    self.startTimer()
                }
            }
        }
    }
    
    // MARK: - Actions
    
    func togglePlayPause() {
        if playerManager.isConnected {
            if isPlaying {
                playerManager.pause()
                timer?.invalidate()
            } else {
                if hasStartedPlaying {
                    playerManager.resume()
                } else {
                    guard let uri = track?.uri else { return }
                    playerManager.play(uri: uri)
                    hasStartedPlaying = true
                    isListeningToState = true
                }
                startTimer()
            }
            isPlaying.toggle()
            onPlayStateChanged?(isPlaying)
        } else {
            guard let uri = track?.uri else { return }
            playerManager.authorize(uri: uri)
        }
    }
    
    func nextTrack() {
        if playerManager.isConnected {
            playerManager.skipToNext()
        } else {
            guard let uri = track?.uri else { return }
            playerManager.authorize(uri: uri)
        }
    }
    
    func previousTrack() {
        if playerManager.isConnected {
            playerManager.skipToPrevious()
        } else {
            guard let uri = track?.uri else { return }
            playerManager.authorize(uri: uri)
        }
    }
    
    func toggleShuffle() {
        isShuffleOn.toggle()
        playerManager.setShuffle(enabled: isShuffleOn)
        onShuffleChanged?(isShuffleOn)
    }
    
    func toggleRepeat() {
        repeatCount = (repeatCount + 1) % 3
        playerManager.setRepeatMode(mode: repeatCount)
        onRepeatChanged?(repeatCount)
    }
    
    func seek(to value: Float) {
        timer?.invalidate()
        let newPosition = Int(value * Float(trackDuration))
        currentPosition = newPosition
        playerManager.seek(to: newPosition)
        updateTimeLabels()
    }
    
    func like(music: Track) {
        FavoritesManager.shared.toggleLike(music: music)
        let isLiked = FavoritesManager.shared.isLiked(music: music)
        likeStateChanged?(isLiked)
    }
    
    
    // MARK: - Timer
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.currentPosition += 1000
            if self.trackDuration > 0 {
                let progress = Float(self.currentPosition) / Float(self.trackDuration)
                self.onProgressChanged?(progress)
                self.updateTimeLabels()
            }
            if self.currentPosition >= self.trackDuration {
                self.timer?.invalidate()
            }
        }
    }
    
    private func updateTimeLabels() {
        let current = formatTime(currentPosition)
        let remaining = "-\(formatTime(trackDuration - currentPosition))"
        onTimeChanged?(current, remaining)
    }
    
    private func formatTime(_ ms: Int) -> String {
        let totalSeconds = max(0, ms / 1000)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    // MARK: - Cleanup
    
    func cleanup() {
        timer?.invalidate()
        timer = nil
        playerManager.onStateChanged = nil
        playerManager.onImageReady = nil
    }
}
