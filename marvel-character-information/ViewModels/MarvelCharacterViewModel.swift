//
//  MarvelCharacterViewModel.swift
//  marvel-character-information
//
//  Created by Bruno Oliveira on 19/09/24.
//

import Foundation

class MarvelCharacterViewModel {
    
    let fetchMarvelCharacters: FetchMarvelCharactersType
    
    init(fetchMarvelCharacters: FetchMarvelCharactersType) {
        self.fetchMarvelCharacters = fetchMarvelCharacters
    }
    
    var characters: [MarvelCharacterModel] = [] {
        didSet {
            onCharactersFetched?(characters)
        }
    }
    var onCharactersFetched: (([MarvelCharacterModel]) -> Void)?
    
    func getMarvelCharacters() {
        fetchMarvelCharacters.fetchProfile { results in
            switch results {
            case .success(let marvelCharacters):
                self.characters = marvelCharacters
            case .failure(let error):
                print("error")
            }
        }
    }
}
