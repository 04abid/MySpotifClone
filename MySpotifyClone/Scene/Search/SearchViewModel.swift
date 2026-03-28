//
//  SearchViewModel.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 24.03.26.
//

import Foundation

class SearchViewModel {
    
    var searchData: Search?
    
    var error: ((String) -> Void)?
    var succes:(() -> Void)?
    
    let useCase: SearchUseCase
    init(useCase: SearchUseCase) {
        self.useCase = useCase
    }
    
    
    func getSearchData(word:String) {
        useCase.getSearchInformations(word: word) { result, errorMessage in
            if let errorMessage {
                self.error?(errorMessage)
            }
            else if let result = result {
                self.searchData = result
                self.succes?()
            }
        }
    }
}
