//
//  AlbumController.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 06.03.26.
//

import UIKit

class AlbumController: UIViewController {
    
    private let viewModel: AlbumViewModel
    init(viewModel: AlbumViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

     
    }
    


}
