//
//  CharacterModel.swift
//  marvel-character-information
//
//  Created by Bruno Oliveira on 19/09/24.
//

public struct MarvelCharacterModel: Codable {
    public let id: Int
    public let name: String
    public let description: String
    public let thumbnail: Thumbnail
    
    public struct Thumbnail: Codable {
        let path: String
        let `extension`: String
    }
    
    var imageUrl: String {
        return "\(thumbnail.path).\(thumbnail.extension)"
    }
}
