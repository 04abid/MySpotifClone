//
//  TabBarController.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 24.02.26.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureControllers()
    }

    private func configureControllers() {
        let home = HomeController()
        let homeNavigation = UINavigationController(rootViewController: home)
        homeNavigation.tabBarItem = .init(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        let search = SearchController()
        let searchNavigation = UINavigationController(rootViewController: search)
        searchNavigation.tabBarItem = .init(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        
        let library = LibraryController()
        let librarNavigation = UINavigationController(rootViewController: library)
        librarNavigation.tabBarItem = .init(title: "Library", image: UIImage(systemName: "music.note.list"), tag: 2)
        
        viewControllers = [homeNavigation,searchNavigation,librarNavigation]
    }
}
