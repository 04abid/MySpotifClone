//
//  CategoryCell.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 28.03.26.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private let icon: UIImageView = {
       let image = UIImageView()
        image.tintColor = .white
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    static let identifier = "CategoryCell"
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureConstraint()
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    private func configureConstraint() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(icon)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
                    
            icon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 4),
            icon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 4),
            icon.widthAnchor.constraint(equalToConstant: 50),
            icon.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    func configure(category: BrowseCategory) {
        titleLabel.text = category.title
        contentView.backgroundColor = category.color
        icon.image = UIImage.init(systemName: category.iconName)
    }
}
