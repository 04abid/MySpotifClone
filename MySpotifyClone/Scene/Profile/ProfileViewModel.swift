//
//  ProfileViewModel.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 03.03.26.
//

import Foundation


class ProfileViewModel {
    
    private let useCase: ProfileUseCase
    init(useCase: ProfileUseCase) {
        self.useCase = useCase
    }
    
    private(set) var profile: UserProfile?
    
    var profileItems: [(title: String, value: String)] {
        guard let profile = profile else { return [] }
        return [
            ("Ad",      profile.displayName ?? "—"),
            ("Email",   profile.email ?? "—"),
            ("Ölkə",    profile.country ?? "—"),
            ("Plan",    profile.product ?? "—"),
            ("ID",      profile.id ?? "—")
        ]
    }
    
    var succes: (() -> Void)?
    var failure: ((String) -> Void)?
    
    func getProfileData() {
        useCase.getCurrentUserProfile { data, errorMessage in
            if let errorMessage {
                self.failure?(errorMessage)
            } else if let data {
                self.profile = data
                self.succes?()
            }
        }
    }
}
