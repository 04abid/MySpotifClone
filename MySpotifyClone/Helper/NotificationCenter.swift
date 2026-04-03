//
//  NotificationCenter.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 10.03.26.
//

import Foundation

extension Notification.Name {
    static let playerStateDidChange = Notification.Name("playerStateDidChange")
    static let playerImageDidChange = Notification.Name("playerImageDidChange")
    static let favoritesDidChange = Notification.Name("favoritesDidChange")
}
