//
//  FetchMarvelCharacters.swift
//  marvel-character-information
//
//  Created by Bruno Oliveira on 19/09/24.
//

import Foundation

enum NetworkError: Error {
    case serverError
    case decodingError
}

protocol FetchMarvelCharactersType: AnyObject {
    func fetchProfile(
        nameStartsWith: String?,
        completion: @escaping(Result<[MarvelCharacterModel], NetworkError>) -> Void
    )
}


class FetchMarvelCharacters: FetchMarvelCharactersType {
    
    func fetchProfile(nameStartsWith: String?, completion: @escaping (Result<[MarvelCharacterModel],NetworkError>) -> Void) {
        let publicKey = "82d985ca3d7bab2bcbe92c37f0ca661d"
        let privateKey = "5bd71e01c7582a252ba8cf53e1666d40abd15555"
        let ts = String(Date().timeIntervalSince1970)
        let hash = md5("\(ts)\(privateKey)\(publicKey)")
        
        var urlString = "https://gateway.marvel.com/v1/public/characters?ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"
        
        if let nameStartsWith = nameStartsWith, !nameStartsWith.isEmpty {
            urlString += "&nameStartsWith=\(nameStartsWith)"
        }
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.serverError))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.sync {
                guard let data = data, error == nil else {
                    completion(.failure(.serverError))
                    return
                }
                
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let dataObject = jsonObject["data"] as? [String: Any],
                       let results = dataObject["results"] as? [[String: Any]] {
                        
                        let marvelCharacters = try JSONDecoder().decode(
                            [MarvelCharacterModel].self,
                            from: JSONSerialization.data(withJSONObject: results)
                        )
                        
                        completion(.success(marvelCharacters))
                        
                    } else {
                        completion(.failure(.decodingError))
                    }
                    
                } catch {
                    completion(.failure(.decodingError))
                }
            }
            
        }.resume()
    }
}

