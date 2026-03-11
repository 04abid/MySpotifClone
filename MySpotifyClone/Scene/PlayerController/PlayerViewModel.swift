//
//  PlayerViewModel.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 06.03.26.
//

import Foundation
import UIKit

class PlayerViewModel {
    let track: Track
    private let playerManager: SpotifyPlayBackManager
    
    // State
    private(set) var isPlaying = false
    private(set) var isShuffleOn = false
    private(set) var repeatCount = 0
    private var hasStartedPlaying = false
    private(set) var currentPosition: Int = 0
    private(set) var trackDuration: Int = 0
    private var timer: Timer?
    
    // UI callback-ler
    var onPlayStateChanged: ((Bool) -> Void)?
    var onTrackChanged: ((String, String) -> Void)?
    var onImageChanged: ((UIImage?) -> Void)?
    var onProgressChanged: ((Float) -> Void)?
    var onTimeChanged: ((String, String) -> Void)?
    var onShuffleChanged: ((Bool) -> Void)?
    var onRepeatChanged: ((Int) -> Void)?
    var onGradientColorChanged: ((UIColor) -> Void)?
    
    // Computed
    var trackName: String { track.name }
    var artistName: String { track.artists.first?.name ?? "" }
    var imageURL: String { track.album.images.first?.url ?? "" }
    var albumName: String { track.album.name }
    
    init(track: Track, playerManager: SpotifyPlayBackManager = .shared) {
        self.track = track
        self.playerManager = playerManager
        self.trackDuration = track.durationMs
        setupListeners()
    }
    
    // MARK: - Listeners
    
    private func setupListeners() {
        playerManager.onStateChanged = { [weak self] isPaused, trackName, artistName, position, duration in
            DispatchQueue.main.async {
                self?.isPlaying = !isPaused
                self?.currentPosition = position
                self?.trackDuration = duration
                
                self?.onPlayStateChanged?(!isPaused)
                self?.onTrackChanged?(trackName, artistName)
                self?.updateTimeLabels()
                
                if !isPaused {
                    self?.startTimer()
                } else {
                    self?.timer?.invalidate()
                }
                
                self?.playerManager.onImageReady = { [weak self] image in
                    DispatchQueue.main.async {
                        self?.onImageChanged?(image)
                        if let color = image?.averageColor {
                            self?.onGradientColorChanged?(color)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Sync
    
    func syncPlayerState() {
        playerManager.getPlayerState { [weak self] isShuffling, repeatValue, position, isPaused in
            DispatchQueue.main.async {
                self?.isShuffleOn = isShuffling
                self?.repeatCount = repeatValue
                
                self?.onShuffleChanged?(isShuffling)
                self?.onRepeatChanged?(repeatValue)
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
                    playerManager.play(uri: track.uri)
                    hasStartedPlaying = true
                }
                startTimer()
            }
            isPlaying.toggle()
            onPlayStateChanged?(isPlaying)
        } else {
            playerManager.authorize(uri: track.uri)
        }
    }
    
    func nextTrack() {
        if playerManager.isConnected {
            playerManager.skipToNext()
        } else {
            playerManager.authorize(uri: track.uri)
        }
    }
    
    func previousTrack() {
        if playerManager.isConnected {
            playerManager.skipToPrevious()
        } else {
            playerManager.authorize(uri: track.uri)
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
        playerManager.onStateChanged = nil
        playerManager.onImageReady = nil
    }
}
