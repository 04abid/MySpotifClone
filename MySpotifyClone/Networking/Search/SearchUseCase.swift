//
//  SearchUseCase.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 24.03.26.
//

import Foundation

protocol SearchUseCase {
    func getSearchInformations(word: String, completion: @escaping((Search?, String?) -> Void))
}
