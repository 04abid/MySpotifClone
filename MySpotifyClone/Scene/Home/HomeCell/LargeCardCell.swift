//
//  LargeCardCell.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 05.03.26.
//

import UIKit

class LargeCardCell: UICollectionViewCell {
    private lazy var musicImage: UIImageView = {
       let i = UIImageView()
        i.contentMode = .scaleAspectFill
        i.translatesAutoresizingMaskIntoConstraints = false
        i.layer.cornerRadius = 12
        i.clipsToBounds = true
        return i
    }()
    
    private let musicLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16,weight: .semibold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let musicSubtitleLabel: UILabel = {
       let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 12,weight: .semibold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    static let identifier = "LargeCardCell"
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        configureConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraint() {
        contentView.addSubview(musicImage)
        contentView.addSubview(musicLabel)
        contentView.addSubview(musicSubtitleLabel)
        
        
            NSLayoutConstraint.activate([
                musicImage.topAnchor.constraint(equalTo: contentView.topAnchor),
                musicImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                musicImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                musicImage.heightAnchor.constraint(equalToConstant: 150),
                
                musicLabel.topAnchor.constraint(equalTo: musicImage.bottomAnchor, constant: 8),
                musicLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
                musicLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
                
                musicSubtitleLabel.topAnchor.constraint(equalTo: musicLabel.bottomAnchor, constant: 4),
                musicSubtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
                musicSubtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4)
            ])
    }
    
    func configure(image:String,title:String,subtitle:String) {
        musicImage.loadImage(data: image)
        musicLabel.text = title
        musicSubtitleLabel.text = subtitle
    }
}
