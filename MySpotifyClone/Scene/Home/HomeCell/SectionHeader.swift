//
//  SectionHeader.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 05.03.26.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    private lazy var header: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var seeAllButton: UIButton = {
       let button = UIButton()
        button.setTitle("See All", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(seeAllButtonTapped), for: .touchUpInside)
        return button
    }()
    
    static let indentifier = "SectionHeader"
    
    var seeAllTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        configureConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func seeAllButtonTapped() {
        seeAllTapped?()
    }
    
    private func configureConstraint() {
        addSubview(header)
        addSubview(seeAllButton)
        
        NSLayoutConstraint.activate([
            header.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            header.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            seeAllButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            seeAllButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configure(title: String,showSeeAll:Bool = true) {
        header.text = title
    }
}
