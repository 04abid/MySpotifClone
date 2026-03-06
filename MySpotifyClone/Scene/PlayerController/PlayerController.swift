//
//  PlayerController.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 06.03.26.
//

import UIKit
//import SpotifyiOS

class PlayerController: BaseController {
    
    private lazy var dismissButton: UIButton = {
       let button = UIButton()
        button.tintColor = .white
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let coverImage: UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let trackNameLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let artistNameLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let actionStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var cancelButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var plusButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let progressSlider: UISlider = {
       let slider = UISlider()
        slider.minimumTrackTintColor = .gray
        slider.maximumTrackTintColor = .white
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.value = 0
        return slider
    }()
    
    
    private let controlStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    private let shuffleButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "shuffle"), for: .normal)
        button.tintColor = .white
        return button
    }()

    private let previousButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "backward.fill"), for: .normal)
        button.tintColor = .white
        return button
    }()

    private lazy var playPauseButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        return button
    }()

    private let nextButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "forward.fill"), for: .normal)
        button.tintColor = .white
        return button
    }()

    private let repeatButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "repeat"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    
    private let viewModel: PlayerViewModel
    
    init(viewModel: PlayerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc private func dismissButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func playButtonTapped() {
//        print("Play basıldı")
//        print("URI: \(viewModel.track.uri)")
//        print("Connected: \(SpotifyPlayBackManager.shared.appRemote.isConnected)")
        SpotifyPlayBackManager.shared.play(uri: viewModel.track.uri)
    }
    
    override func configureConstraint() {
        
            view.addSubview(dismissButton)
            view.addSubview(titleLabel)
            view.addSubview(coverImage)
            view.addSubview(trackNameLabel)
            view.addSubview(artistNameLabel)
            view.addSubview(actionStack)
            view.addSubview(progressSlider)
            view.addSubview(controlStack)
            
            actionStack.addArrangedSubview(cancelButton)
            actionStack.addArrangedSubview(plusButton)
            
            controlStack.addArrangedSubview(shuffleButton)
            controlStack.addArrangedSubview(previousButton)
            controlStack.addArrangedSubview(playPauseButton)
            controlStack.addArrangedSubview(nextButton)
            controlStack.addArrangedSubview(repeatButton)
            
            NSLayoutConstraint.activate([
                // Dismiss button - sol yuxarı
                dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
                dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                
                // Title label - ortada yuxarı
                titleLabel.centerYAnchor.constraint(equalTo: dismissButton.centerYAnchor),
                titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                // Cover image - ortada böyük
                coverImage.topAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: 30),
                coverImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                coverImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
                coverImage.heightAnchor.constraint(equalTo: coverImage.widthAnchor),
                
                // Track name - şəklin altında
                trackNameLabel.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: 24),
                trackNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                
                // Artist name - track adının altında
                artistNameLabel.topAnchor.constraint(equalTo: trackNameLabel.bottomAnchor, constant: 4),
                artistNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                
                // Action stack - sağda, track name ilə eyni hündürlükdə
                actionStack.centerYAnchor.constraint(equalTo: trackNameLabel.centerYAnchor),
                actionStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
                
                // Progress slider
                progressSlider.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor, constant: 48),
                progressSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                progressSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
                
                // Control stack
                controlStack.topAnchor.constraint(equalTo: progressSlider.bottomAnchor, constant: 24),
                controlStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                controlStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
                
                // Play button böyük
                playPauseButton.widthAnchor.constraint(equalToConstant: 60),
                playPauseButton.heightAnchor.constraint(equalToConstant: 60)
            ])
        }
    
    override func configureUI() {
        view.backgroundColor = UIColor(white: 0.1, alpha: 1)
        coverImage.loadImage(data: viewModel.imageURL)
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
    }
}
