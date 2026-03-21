//
//  AuthUseCase.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 26.02.26.
//

import Foundation


protocol AuthUseCase {
   func exchangeCodeForToken(code: String, completion: @escaping ((AuthResponse?,String?) -> Void))
    func cacheToken(result: AuthResponse)
    func refreshAccessToken(completion: @escaping (Bool) -> Void)
}
