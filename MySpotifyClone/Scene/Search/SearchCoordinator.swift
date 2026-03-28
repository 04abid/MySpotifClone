//
//  SearchCoordinator.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 05.03.26.
//

import UIKit


class SearchCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = SearchController(viewModel: SearchViewModel(useCase: SearchManager()))
        navigationController.show(controller, sender: nil)
    }
}
