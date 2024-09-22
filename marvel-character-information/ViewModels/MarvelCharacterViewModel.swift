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
    var onErrorOccurred: ((String) -> Void)?
    
    func getMarvelCharacters(nameStartsWith: String?) {
        fetchMarvelCharacters.fetchProfile(nameStartsWith: nameStartsWith) { results in
            switch results {
            case .success(let marvelCharacters):
                self.characters = marvelCharacters
            case .failure:
                self.onErrorOccurred?("Check your network connection")
            }
        }
    }
    
    func searchCharacters(query: String) {
        self.getMarvelCharacters(nameStartsWith: query)
    }
}
