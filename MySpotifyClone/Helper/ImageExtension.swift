//
//  ImageExtension.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 03.03.26.
//


import UIKit
import Kingfisher

extension UIImageView {
    func loadImage(data: String) {
       let url = URL(string: data)
        kf.setImage(with: url)
    }
}
