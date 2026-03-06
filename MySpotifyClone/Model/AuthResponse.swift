//
//  AuthResponse.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 25.02.26.
//

import Foundation

struct AuthResponse: Codable {
    let accessToken: String?
    let refreshToken: String?
    let expiresIn: Int?
    let tokenType: String?
    let scope: String?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
        case scope = "scope"
    }
}

