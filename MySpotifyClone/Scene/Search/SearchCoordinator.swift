//
//  SearchCoordinator.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 05.03.26.
//

import UIKit


protocol SearchCordinatorDelegate {
    func didTapTrack(track: Track)
}

class SearchCoordinator: Coordinator {
    var navigationController: UINavigationController
    
     var searchCordinatorDelegate: SearchCordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = SearchController(viewModel: SearchViewModel(useCase: SearchManager()))
        controller.searchResult.delegate = self
        navigationController.show(controller, sender: nil)
    }
}

extension SearchCoordinator:SearchMusicDelegate {
    func searchMusicTapped(trackID: Track) {
        searchCordinatorDelegate?.didTapTrack(track: trackID)
    }
}


