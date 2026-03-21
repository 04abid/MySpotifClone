//
//  AlbumHeaderView.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 21.03.26.
//

import UIKit

class AlbumHeaderView: UIView {
    
    private var headerImage: UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let albumNameLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 2
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let artisNameLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.numberOfLines = 2
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let albumRelaseDate: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 8, weight: .bold)
        label.numberOfLines = 2
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var playButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .green
        button.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .green
//        button.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var shuffleButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .green
//        button.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)
        return button
    }()
    
    private let gradientLayer = CAGradientLayer()
    
    var playButtonTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.darkGray.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.0, 1.0]
    }
    
    private func configureConstraint() {
        layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.colors = [UIColor.darkGray.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        
        addSubview(headerImage)
        addSubview(albumNameLabel)
        addSubview(artisNameLabel)
        addSubview(playButton)
        addSubview(albumRelaseDate)
        
        NSLayoutConstraint.activate([
            headerImage.topAnchor.constraint(equalTo: topAnchor),
            headerImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            headerImage.widthAnchor.constraint(equalToConstant: 200),
            headerImage.heightAnchor.constraint(equalToConstant: 200),
            
            albumNameLabel.topAnchor.constraint(equalTo: headerImage.bottomAnchor, constant: 40),
            albumNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            
            artisNameLabel.topAnchor.constraint(equalTo: albumNameLabel.bottomAnchor),
            artisNameLabel.leadingAnchor.constraint(equalTo: albumNameLabel.leadingAnchor),
            
            albumRelaseDate.topAnchor.constraint(equalTo: artisNameLabel.bottomAnchor),
            albumRelaseDate.leadingAnchor.constraint(equalTo: artisNameLabel.leadingAnchor),
            
            playButton.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -16),
            playButton.centerYAnchor.constraint(equalTo: albumNameLabel.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 48),
            playButton.heightAnchor.constraint(equalToConstant: 48),
            
        ])
    }
    
    @objc func didTapPlayButton() {
        playButtonTapped?()
    }
    
    func configure(data: Album) {
        headerImage.loadImage(data: data.images.first?.url ?? "")
        albumNameLabel.text = data.name
        artisNameLabel.text = data.artists.first?.name
        albumRelaseDate.text = data.releaseDate
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            if let color = self?.headerImage.image?.averageColor {
                self?.gradientLayer.colors = [color.withAlphaComponent(0.7).cgColor, UIColor.black.cgColor]
            }
        }
    }
}
