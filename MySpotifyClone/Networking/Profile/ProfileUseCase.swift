//
//  ProfileUseCase.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 03.03.26.
//

import Foundation

protocol ProfileUseCase {
    func getCurrentUserProfile(completion: @escaping((UserProfile?,String?) -> Void))
}
