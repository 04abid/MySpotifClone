//
//  AppCoordinator.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 05.03.26.
//

import UIKit

protocol HomeCoordinatorDelegate: AnyObject {
    func homeCoordinatorDidTapTrack(_ track: Track)
}

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    private var tabBar: UITabBarController?
    private let miniPlayer = MiniPlayerView()
    private var playerTransitionManager: PlayerTransitionManager?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let tabBar = UITabBarController()
        self.tabBar = tabBar
        
        let homeNav = UINavigationController()
        homeNav.tabBarItem = .init(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        let homeCoordinator = HomeCoordinator(navigationController: homeNav)
        homeCoordinator.playerDelegate = self
        homeCoordinator.start()
        childCoordinators.append(homeCoordinator)
        
        let searchNav = UINavigationController()
        searchNav.tabBarItem = .init(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        let searchCoordinator = SearchCoordinator(navigationController: searchNav)
        searchCoordinator.searchCordinatorDelegate = self
        searchCoordinator.start()
        childCoordinators.append(searchCoordinator)
        
        let libraryNav = UINavigationController()
        libraryNav.tabBarItem = .init(title: "Library", image: UIImage(systemName: "music.note.list"), tag: 2)
        let libraryCoordinator = LibraryCoordinator(navigationController: libraryNav)
        libraryCoordinator.delegate = self
        libraryCoordinator.start()
        childCoordinators.append(libraryCoordinator)
        
        tabBar.viewControllers = [homeNav, searchNav, libraryNav]
        setupMiniPlayer(in: tabBar)
        
        navigationController.setViewControllers([tabBar], animated: true)
        navigationController.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - MiniPlayer Setup
    
    private func setupMiniPlayer(in tabBar: UITabBarController) {
        tabBar.view.addSubview(miniPlayer)
        NSLayoutConstraint.activate([
            miniPlayer.leadingAnchor.constraint(equalTo: tabBar.view.leadingAnchor, constant: 8),
            miniPlayer.trailingAnchor.constraint(equalTo: tabBar.view.trailingAnchor, constant: -8),
            miniPlayer.bottomAnchor.constraint(equalTo: tabBar.tabBar.topAnchor, constant: -4),
            miniPlayer.heightAnchor.constraint(equalToConstant: 56)
        ])
        miniPlayer.layer.cornerRadius = 8
        miniPlayer.clipsToBounds = true
        
        miniPlayer.onTap = { [weak self] in
            self?.expandPlayer()
        }
    }
    
    // MARK: - Player Navigation
    
    /// Yeni mahnıya tap — Track modeli var
    func openPlayer(for track: Track) {
        let viewModel = PlayerViewModel(track: track)
        let playerVC = PlayerController(viewModel: viewModel)
        presentPlayer(playerVC)
    }
    
    /// Mini player tap — Track modeli YOX, PlaybackManager-dan oxuyuruq
    private func expandPlayer() {
        // Track-sız init — cari çalan mahnının məlumatını PlaybackManager-dan alır
        let viewModel = PlayerViewModel()
        let playerVC = PlayerController(viewModel: viewModel)
        presentPlayer(playerVC)
    }
    
    private func presentPlayer(_ playerVC: PlayerController) {
        let transitionManager = PlayerTransitionManager()
        self.playerTransitionManager = transitionManager
        
        playerVC.modalPresentationStyle = .overFullScreen
        transitionManager.attach(to: playerVC)
        
        transitionManager.onDismissCompleted = { [weak self] in
            self?.showMiniPlayer()
        }
        playerVC.onDismissed = { [weak self] in
            self?.showMiniPlayer()
        }
        
        hideMiniPlayer()
        
        if let topVC = tabBar?.selectedViewController {
            topVC.present(playerVC, animated: true)
        }
    }
    
    // MARK: - MiniPlayer Visibility
    
    private func showMiniPlayer() {
        UIView.animate(withDuration: 0.25) {
            self.miniPlayer.show()
            self.miniPlayer.alpha = 1
        }
        updateCollectionInsets(miniPlayerVisible: true)
    }
    
    private func hideMiniPlayer() {
        UIView.animate(withDuration: 0.15) {
            self.miniPlayer.alpha = 0
        } completion: { _ in
            self.miniPlayer.hide()
        }
        updateCollectionInsets(miniPlayerVisible: false)
    }
    
    private func updateCollectionInsets(miniPlayerVisible: Bool) {
        let bottomInset: CGFloat = miniPlayerVisible ? 68 : 0
        guard let viewControllers = tabBar?.viewControllers else { return }
        for nav in viewControllers {
            if let navController = nav as? UINavigationController,
               let topVC = navController.topViewController {
                for subview in topVC.view.subviews {
                    if let collectionView = subview as? UICollectionView {
                        collectionView.contentInset.bottom = bottomInset
                        collectionView.verticalScrollIndicatorInsets.bottom = bottomInset
                    }
                }
            }
        }
    }
}

extension AppCoordinator: HomeCoordinatorDelegate {
    func homeCoordinatorDidTapTrack(_ track: Track) {
        openPlayer(for: track)
    }
}

extension AppCoordinator: SearchCordinatorDelegate {
    func didTapTrack(track: Track) {
        openPlayer(for: track)
    }
}
extension AppCoordinator: LibraryCoordinatorDelegate {
    func passData(music: Track) {
        openPlayer(for: music)
    }
}
