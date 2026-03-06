//
//  Coordinator.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 05.03.26.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController{get set}
    
    func start()
}
