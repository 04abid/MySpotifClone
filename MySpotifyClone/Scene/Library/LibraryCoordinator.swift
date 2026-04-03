//
//  LibraryCoordinator.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 05.03.26.
//

import UIKit

protocol LibraryCoordinatorDelegate {
    func passData(music:Track)
}

class LibraryCoordinator: Coordinator {
    
    
    var navigationController: UINavigationController
     var delegate: LibraryCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = LibraryController()
        controller.delegate = self
        navigationController.show(controller, sender: nil)
    }
}

extension LibraryCoordinator: LibraryControllerDelegate {
    func sendData(musicID: Track) {
        delegate?.passData(music: musicID)
    }
}
