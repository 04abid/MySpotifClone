//
//  SearchCategory.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 28.03.26.
//
 
import UIKit

struct BrowseCategory {
    let title: String
    let color: UIColor
    let iconName: String
}

let categories = [
    BrowseCategory(title: "Musiqi", color: UIColor(red: 0.88, green: 0.20, blue: 0.47, alpha: 1), iconName: "music.note"),
    BrowseCategory(title: "Podkastlar", color: UIColor(red: 0, green: 0.39, blue: 0.31, alpha: 1), iconName: "mic.fill"),
    BrowseCategory(title: "Canlı Tədbirlər", color: UIColor(red: 0.52, green: 0.22, blue: 0.67, alpha: 1), iconName: "person.2.fill"),
    BrowseCategory(title: "Sənin üçün", color: UIColor(red: 0.12, green: 0.20, blue: 0.39, alpha: 1), iconName: "heart.fill"),
    BrowseCategory(title: "Reytinqlər", color: UIColor(red: 0.55, green: 0.40, blue: 0.67, alpha: 1), iconName: "chart.bar.fill"),
    BrowseCategory(title: "Yeni buraxılışlar", color: UIColor(red: 0.69, green: 0.38, blue: 0.22, alpha: 1), iconName: "sparkles"),
    BrowseCategory(title: "Əhval-ruhiyyə", color: UIColor(red: 0.28, green: 0.49, blue: 0.58, alpha: 1), iconName: "face.smiling.fill"),
    BrowseCategory(title: "Hip-Hop", color: UIColor(red: 0.73, green: 0.36, blue: 0.03, alpha: 1), iconName: "flame.fill"),
    BrowseCategory(title: "Pop", color: UIColor(red: 0.08, green: 0.54, blue: 0.03, alpha: 1), iconName: "music.mic"),
    BrowseCategory(title: "Rock", color: UIColor(red: 0.90, green: 0.12, blue: 0.20, alpha: 1), iconName: "guitars.fill"),
    BrowseCategory(title: "Chill", color: UIColor(red: 0.33, green: 0.48, blue: 0.65, alpha: 1), iconName: "leaf.fill"),
    BrowseCategory(title: "Yuxu", color: UIColor(red: 0.12, green: 0.20, blue: 0.39, alpha: 1), iconName: "moon.fill"),
]
