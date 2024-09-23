//
//  FavoriteManager+Utils.swift
//  marvel-character-information
//
//  Created by Bruno Oliveira on 22/09/24.
//

import UIKit

extension Notification.Name {
    static let favoritesUpdated = Notification.Name("favoritesUpdated")
}

class FavoriteManager {
    private let favoritesKey = "favoriteCharacters"

    // Recupera a lista de personagens favoritos
    public func getFavoriteCharacters() -> [MarvelCharacterModel] {
        guard let data = UserDefaults.standard.data(forKey: favoritesKey) else { return [] }
        do {
            let characters = try JSONDecoder().decode([MarvelCharacterModel].self, from: data)
            return characters
        } catch {
            print("Erro ao decodificar personagens favoritos: \(error)")
            return []
        }
    }

    // Adiciona um personagem aos favoritos
    public func addFavorite(character: MarvelCharacterModel) {
        var favorites = getFavoriteCharacters()
        favorites.append(character)
        saveFavorites(favorites)
    }

    // Remove um personagem dos favoritos
    public func removeFavorite(characterID: Int) {
        var favorites = getFavoriteCharacters()
        favorites.removeAll { $0.id == characterID }
        saveFavorites(favorites)
    }

    // Verifica se um personagem é favorito
    public func isFavorite(characterID: Int) -> Bool {
        return getFavoriteCharacters().contains { $0.id == characterID }
    }

    // Salva a lista de favoritos no UserDefaults
    private func saveFavorites(_ characters: [MarvelCharacterModel]) {
        do {
            let data = try JSONEncoder().encode(characters)
            UserDefaults.standard.set(data, forKey: favoritesKey)
        } catch {
            print("Erro ao salvar personagens favoritos: \(error)")
        }
    }
}
