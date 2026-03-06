//
//  HomeCoordinator.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 05.03.26.
//

import UIKit


class HomeCoordinator:Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = HomeController()
        controller.delegate = self
        navigationController.show(controller, sender: nil)
    }
}

extension HomeCoordinator:HomeControllerDelegate {
    
    
    func didTapTrack(track: Track) {
        let controller = PlayerController(viewModel: PlayerViewModel(track: track))
        controller.modalPresentationStyle = .fullScreen
        navigationController.present(controller, animated: true)
    }
    
    func didTapAlbum(album: Album) {
        let controller = AlbumController(viewModel: AlbumViewModel(album: album))
        controller.modalPresentationStyle = .fullScreen
        navigationController.present(controller, animated: true)
    }
    
    func showProfile() {
        let controller = SettingsController()
        navigationController.show(controller, sender: nil)
    }
    
    func didTapSeeAll(section: HomeSection) {
        // yaxinda
    }
}
