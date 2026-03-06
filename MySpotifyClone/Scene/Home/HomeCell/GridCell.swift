//
//  GridCell.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 05.03.26.
//

import UIKit

class GridCell: UICollectionViewCell {
    
    private lazy var musicImage: UIImageView = {
       let i = UIImageView()
        i.contentMode = .scaleAspectFill
        i.translatesAutoresizingMaskIntoConstraints = false
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
    
    static let identifier = "GridCell"
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        configureConstraint()
        contentView.backgroundColor = UIColor(white: 0.15, alpha: 1)
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraint() {
        contentView.addSubview(musicImage)
        contentView.addSubview(musicLabel)
        
        NSLayoutConstraint.activate([
            musicImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            musicImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            musicImage.widthAnchor.constraint(equalTo: contentView.heightAnchor),
            musicImage.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            
            musicLabel.leadingAnchor.constraint(equalTo: musicImage.trailingAnchor,constant: 8),
            musicLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            musicLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(image:String,label: String) {
        musicImage.loadImage(data: image)
        musicLabel.text = label
    }
}
