//
//  AppCoordinator.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 05.03.26.
//

import UIKit


class AppCoordinator:Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let tabBar = UITabBarController()
        
        let homeNav = UINavigationController()
        homeNav.tabBarItem = .init(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        let homeCordinator = HomeCoordinator(navigationController: homeNav)
        homeCordinator.start()
        childCoordinators.append(homeCordinator)
        
        
        let searchNav = UINavigationController()
        searchNav.tabBarItem = .init(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        let searchCoordinator = SearchCoordinator(navigationController: searchNav)
        searchCoordinator.start()
        childCoordinators.append(searchCoordinator)
        
        let libraryNav = UINavigationController()
        libraryNav.tabBarItem = .init(title: "Library", image: UIImage(systemName: "music.note.list"), tag: 2)
        let librarcoordinator = LibraryCoordinator(navigationController: libraryNav)
        librarcoordinator.start()
        childCoordinators.append(librarcoordinator)
        
        tabBar.viewControllers = [homeNav,searchNav,libraryNav]
        navigationController.setViewControllers([tabBar], animated: true)
        navigationController.setNavigationBarHidden(true, animated: true)
    }
    
    
}
