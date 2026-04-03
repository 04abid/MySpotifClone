//
//  PlayerController.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 06.03.26.
//

import UIKit


class PlayerController: BaseController {
    
    var onDismissed: (() -> Void)?
    
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
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var progressSlider: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = .white
        slider.maximumTrackTintColor = UIColor(white: 0.3, alpha: 1)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.value = 0
        slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        return slider
    }()
    
    private let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = .lightGray
        label.text = "0:00"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let remainingTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = .lightGray
        label.text = "0:00"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let controlStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var shuffleButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "shuffle"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(shuffleButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var previousButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "backward.fill"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var playPauseButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "forward.fill"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var repeatButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "repeat"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(repeatButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let gradientLayer = CAGradientLayer()
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    override func configureConstraint() {
        gradientLayer.locations = [0.0, 0.7]
        gradientLayer.colors = [UIColor.darkGray.cgColor, UIColor.black.cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        view.addSubview(dismissButton)
        view.addSubview(titleLabel)
        view.addSubview(coverImage)
        view.addSubview(trackNameLabel)
        view.addSubview(artistNameLabel)
        view.addSubview(actionStack)
        view.addSubview(progressSlider)
        view.addSubview(currentTimeLabel)
        view.addSubview(remainingTimeLabel)
        view.addSubview(controlStack)
        
        actionStack.addArrangedSubview(cancelButton)
        actionStack.addArrangedSubview(plusButton)
        
        controlStack.addArrangedSubview(shuffleButton)
        controlStack.addArrangedSubview(previousButton)
        controlStack.addArrangedSubview(playPauseButton)
        controlStack.addArrangedSubview(nextButton)
        controlStack.addArrangedSubview(repeatButton)
        
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            titleLabel.centerYAnchor.constraint(equalTo: dismissButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            coverImage.topAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: 30),
            coverImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            coverImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            coverImage.heightAnchor.constraint(equalTo: coverImage.widthAnchor),
            
            trackNameLabel.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: 24),
            trackNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            artistNameLabel.topAnchor.constraint(equalTo: trackNameLabel.bottomAnchor, constant: 4),
            artistNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            actionStack.centerYAnchor.constraint(equalTo: trackNameLabel.centerYAnchor),
            actionStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            progressSlider.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor, constant: 48),
            progressSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            progressSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            currentTimeLabel.topAnchor.constraint(equalTo: progressSlider.bottomAnchor, constant: 4),
            currentTimeLabel.leadingAnchor.constraint(equalTo: progressSlider.leadingAnchor),
            
            remainingTimeLabel.topAnchor.constraint(equalTo: progressSlider.bottomAnchor, constant: 4),
            remainingTimeLabel.trailingAnchor.constraint(equalTo: progressSlider.trailingAnchor),
            
            controlStack.topAnchor.constraint(equalTo: currentTimeLabel.bottomAnchor, constant: 24),
            controlStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            controlStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            playPauseButton.widthAnchor.constraint(equalToConstant: 60),
            playPauseButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    override func configureUI() {
        view.backgroundColor = UIColor(white: 0.1, alpha: 1)
        titleLabel.text = "Çalan Sarki"
        
        // Track varsa URL-dən yüklə, yoxdursa PlaybackManager-dan son image-i göstər
        if !viewModel.imageURL.isEmpty {
            coverImage.loadImage(data: viewModel.imageURL)
        } else if let lastImage = viewModel.currentImage {
            coverImage.image = lastImage
        }
        
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        
        progressSlider.setThumbImage(makeThumbImage(size: 16, color: .white), for: .normal)
        progressSlider.setThumbImage(makeThumbImage(size: 16, color: .white), for: .highlighted)
        
        bindViewModel()
        viewModel.syncPlayerState()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            if let color = self?.coverImage.image?.averageColor {
                self?.gradientLayer.colors = [color.withAlphaComponent(0.7).cgColor, UIColor.black.cgColor]
            }
        }
    }
    
    private func bindViewModel() {
        viewModel.onPlayStateChanged = { [weak self] isPlaying in
            let icon = isPlaying ? "pause.circle.fill" : "play.circle.fill"
            self?.playPauseButton.setImage(UIImage(systemName: icon), for: .normal)
        }
        
        viewModel.onTrackChanged = { [weak self] name, artist in
            self?.trackNameLabel.text = name
            self?.artistNameLabel.text = artist
        }
        
        viewModel.onImageChanged = { [weak self] image in
            self?.coverImage.image = image
        }
        
        viewModel.onProgressChanged = { [weak self] progress in
            self?.progressSlider.value = progress
        }
        
        viewModel.onTimeChanged = { [weak self] current, remaining in
            self?.currentTimeLabel.text = current
            self?.remainingTimeLabel.text = remaining
        }
        
        viewModel.onShuffleChanged = { [weak self] isOn in
            self?.shuffleButton.tintColor = isOn ? .green : .white
        }
        
        viewModel.onRepeatChanged = { [weak self] mode in
            switch mode {
            case 0:
                self?.repeatButton.setImage(UIImage(systemName: "repeat"), for: .normal)
                self?.repeatButton.tintColor = .white
            case 1:
                self?.repeatButton.setImage(UIImage(systemName: "repeat"), for: .normal)
                self?.repeatButton.tintColor = .green
            case 2:
                self?.repeatButton.setImage(UIImage(systemName: "repeat.1"), for: .normal)
                self?.repeatButton.tintColor = .green
            default:
                break
            }
        }
        
        viewModel.onGradientColorChanged = { [weak self] color in
            let animation = CABasicAnimation(keyPath: "colors")
            animation.fromValue = self?.gradientLayer.colors
            animation.toValue = [color.withAlphaComponent(0.7).cgColor, UIColor.black.cgColor]
            animation.duration = 0.5
            self?.gradientLayer.colors = [color.withAlphaComponent(0.7).cgColor, UIColor.black.cgColor]
            self?.gradientLayer.add(animation, forKey: "colorChange")
        }
        
        viewModel.likeStateChanged = { [weak self] success in
            if success {
                self?.plusButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                self?.plusButton.tintColor = .green
            } else {
                self?.plusButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
                self?.plusButton.tintColor = .white
            }
        }
    }
    
    private func makeThumbImage(size: CGFloat, color: UIColor) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
        return renderer.image { ctx in
            let rect = CGRect(origin: .zero, size: CGSize(width: size, height: size))
            ctx.cgContext.setFillColor(color.cgColor)
            ctx.cgContext.fillEllipse(in: rect)
        }
    }
}

// MARK: - Actions

extension PlayerController {
    @objc private func dismissButtonTapped() {
        viewModel.cleanup()
        dismiss(animated: true) { [weak self] in
            self?.onDismissed?()
        }
    }
    @objc func playButtonTapped() { viewModel.togglePlayPause() }
    @objc func nextButtonTapped() { viewModel.nextTrack() }
    @objc func previousButtonTapped() { viewModel.previousTrack() }
    @objc func shuffleButtonTapped() { viewModel.toggleShuffle() }
    @objc func repeatButtonTapped() { viewModel.toggleRepeat() }
    @objc func sliderChanged() { viewModel.seek(to: progressSlider.value) }
    @objc func plusButtonTapped() {
        guard let track = viewModel.track else {return}
        viewModel.like(music: track)
    }
}
