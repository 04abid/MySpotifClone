//
//  MiniPlayerView.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 10.03.26.
//

import UIKit


class MiniPlayerView: UIView {
    private let coverImage: UIImageView = {
           let image = UIImageView()
           image.contentMode = .scaleAspectFill
           image.clipsToBounds = true
           image.layer.cornerRadius = 4
           image.translatesAutoresizingMaskIntoConstraints = false
           return image
       }()
       
    private let trackNameLabel: UILabel = {
           let label = UILabel()
           label.font = .systemFont(ofSize: 14, weight: .semibold)
           label.textColor = .white
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
       
    private let artistNameLabel: UILabel = {
           let label = UILabel()
           label.font = .systemFont(ofSize: 12, weight: .regular)
           label.textColor = .lightGray
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
    
    private lazy var playPauseButton: UIButton = {
           let button = UIButton()
           button.setImage(UIImage(systemName: "play.fill"), for: .normal)
           button.tintColor = .white
           button.translatesAutoresizingMaskIntoConstraints = false
           button.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
           return button
       }()
       
    private let progressView: UIProgressView = {
           let progress = UIProgressView(progressViewStyle: .default)
           progress.trackTintColor = UIColor(white: 0.3, alpha: 1)
           progress.progressTintColor = .white
           progress.translatesAutoresizingMaskIntoConstraints = false
           return progress
       }()
    
    private var isPlaying = false
    var onTap: (() -> Void)?
    var onPlayPauseTap: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
        configureNotifications()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setUpUI() {
        backgroundColor = UIColor(white: 0.15, alpha: 1)
        translatesAutoresizingMaskIntoConstraints = false
        isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(tap)
        
        addSubview(progressView)
        addSubview(coverImage)
        addSubview(trackNameLabel)
        addSubview(artistNameLabel)
        addSubview(playPauseButton)
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: topAnchor),
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2),
            
            coverImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            coverImage.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 1),
            coverImage.widthAnchor.constraint(equalToConstant: 40),
            coverImage.heightAnchor.constraint(equalToConstant: 40),
            
            trackNameLabel.leadingAnchor.constraint(equalTo: coverImage.trailingAnchor, constant: 12),
            trackNameLabel.trailingAnchor.constraint(equalTo: playPauseButton.leadingAnchor, constant: -12),
            trackNameLabel.topAnchor.constraint(equalTo: coverImage.topAnchor, constant: 2),
            
            artistNameLabel.leadingAnchor.constraint(equalTo: coverImage.trailingAnchor, constant: 12),
            artistNameLabel.trailingAnchor.constraint(equalTo: playPauseButton.leadingAnchor, constant: -12),
            artistNameLabel.topAnchor.constraint(equalTo: trackNameLabel.bottomAnchor, constant: 2),
            
            playPauseButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            playPauseButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            playPauseButton.widthAnchor.constraint(equalToConstant: 30),
            playPauseButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    
    private func configureNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleStateChange(_:)), name: .playerStateDidChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleImageChange(_:)), name: .playerImageDidChange, object: nil)
        
    }
    
    @objc func viewTapped() {
        onTap?()
    }

    @objc private func handleImageChange(_ notification: Notification) {
        guard let image = notification.userInfo?["image"] as? UIImage else {return}
        DispatchQueue.main.async {
            self.coverImage.image = image
        }
    }

    @objc private func handleStateChange(_ notification: Notification) {
        guard let info = notification.userInfo else {return}
        let isPaused = info["isPaused"] as? Bool ?? true
        let trackName = info["trackName"] as? String ?? ""
        let artistName = info["artistName"] as? String ?? ""
        let position = info["position"] as? Int ?? 0
        let duration = info["duration"] as? Int ?? 0
        
        self.isPlaying = !isPaused
        self.trackNameLabel.text = trackName
        self.artistNameLabel.text = artistName
        
        
        let icon = isPaused ? "play.fill" : "pause.fill"
        self.playPauseButton.setImage(UIImage(systemName: icon), for: .normal)
        
        if duration > 0 {
            self.progressView.progress = Float(position) / Float(duration)
        }
        self.isHidden = false
    }
    
    @objc func playPauseButtonTapped() {
        if isPlaying {
            SpotifyPlayBackManager.shared.pause()
        } else {
            SpotifyPlayBackManager.shared.resume()
        }
    }
    
    func show() {
        isHidden = false
    }
    
    func hide() {
        isHidden = true
    }
}
