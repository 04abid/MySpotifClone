//
//  SettingsViewModel.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 03.03.26.
//

import Foundation



class SettingsViewModel {
    private(set) var sections = [Section]()
    
    func addSection(_ section: Section) {
        sections.append(section)
    }
    
    func clearSections() {
        sections.removeAll()
    }
}
