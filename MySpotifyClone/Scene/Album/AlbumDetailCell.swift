//
//  AlbumDetailCell.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 21.03.26.
//

import UIKit

class AlbumDetailCell: UITableViewCell {
    
    private let trackNameLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 2
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let trackArtisLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.numberOfLines = 2
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let trackDurationLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.numberOfLines = 2
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    static let identifier = "AlbumDetailCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black
        selectionStyle = .none
        configureConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraint() {
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(trackArtisLabel)
        contentView.addSubview(trackDurationLabel)
        
        NSLayoutConstraint.activate([
            trackNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            trackNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            trackArtisLabel.topAnchor.constraint(equalTo: trackNameLabel.bottomAnchor, constant: 4),
            trackArtisLabel.leadingAnchor.constraint(equalTo: trackNameLabel.leadingAnchor),
            
            trackDurationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            trackDurationLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(track: AlbumTrack) {
        trackNameLabel.text = track.name
        trackArtisLabel.text = track.artists.first?.name
        trackDurationLabel.text = formatTime(track.durationMs)
    }
    
    private func formatTime(_ ms: Int) -> String {
        let totalSeconds = max(0, ms / 1000)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes,seconds)
    }
}
