//
//  SearchCell.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 28.03.26.
//

import UIKit

class SearchCell: UITableViewCell {
    
    private  let searchLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 16)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let picture: UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 12
        return image
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureConstraint()
        backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraint() {
        contentView.addSubview(searchLabel)
        contentView.addSubview(picture)
        
        NSLayoutConstraint.activate([
            picture.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            picture.centerYAnchor.constraint(equalTo: centerYAnchor),
            picture.heightAnchor.constraint(equalToConstant: 50),
            picture.widthAnchor.constraint(equalToConstant: 50),
            
            searchLabel.leadingAnchor.constraint(equalTo: picture.trailingAnchor,constant: 8),
            searchLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func configure(data: ReusableSearch) {
        searchLabel.text = data.musicName
        picture.loadImage(data: data.musicImage)
    }
}
