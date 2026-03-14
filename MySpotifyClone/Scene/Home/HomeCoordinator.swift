//
//  HomeCoordinator.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 05.03.26.
//

import UIKit



// MARK: - HomeCoordinator (Yenilənmiş)

class HomeCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    /// Track tap-ını AppCoordinator-a yönləndirmək üçün
    weak var playerDelegate: HomeCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = HomeController()
        controller.delegate = self
        navigationController.show(controller, sender: nil)
    }
}

extension HomeCoordinator: HomeControllerDelegate {
    
    func didTapTrack(track: Track) {
        // ---- DƏYİŞİKLİK: Artıq burada present etmirik ----
        // Əvvəlki kod (SİLİNDİ):
        //   let controller = PlayerController(viewModel: PlayerViewModel(track: track))
        //   controller.modalPresentationStyle = .fullScreen
        //   navigationController.present(controller, animated: true)
        
        // YENİ: AppCoordinator-a delegate et (mini player + transition idarəsi orada)
        playerDelegate?.homeCoordinatorDidTapTrack(track)
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
        // yaxında
    }
}
