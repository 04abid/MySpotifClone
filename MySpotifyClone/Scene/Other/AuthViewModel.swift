//
//  AuthViewModel.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 26.02.26.
//

import Foundation


class AuthViewModel {
    
    private var useCase: AuthUseCase
    init(useCase: AuthUseCase = AuthManager(manager: CoreManager())) {
        self.useCase = useCase
    }
    
    var failure: ((String) -> Void)?
    var succes:(() -> Void)?
    
    var signURL: URL? {
        useCase.signInURL
    }
    
    func signIn(code:String) {
        useCase.exchangeCodeForToken(code: code) { [weak self] data, errorMessage in
            if let errorMessage {
                self?.failure?(errorMessage)
            } else if let data {
                //                print(data)
                self?.useCase.cacheToken(result: data)
                self?.succes?()
            }
        }
    }
}
