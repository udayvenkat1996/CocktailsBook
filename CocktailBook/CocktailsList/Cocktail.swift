//
//  Cocktail.swift
//  CocktailBook
//
//  Created by Uday Venkat on 19/06/24.
//

import Foundation

struct Cocktail: Decodable, Identifiable {
    let id: String
    let name: String
    let type: String
    let shortDescription: String
    let longDescription: String
    let preparationMinutes: Int
    let imageName: String
    let ingredients: [String]
    var isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case shortDescription
        case longDescription
        case preparationMinutes
        case imageName
        case ingredients
    }
}
