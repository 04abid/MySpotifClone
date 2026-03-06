//
//  SettingsModel.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 03.03.26.
//

import Foundation


struct Section {
    let title: String
    let option: [Options]
}


struct Options {
    let title: String
    let handler: () -> Void
}
