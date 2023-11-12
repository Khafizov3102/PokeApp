//
//  Pokemon.swift
//  PokeApp
//
//  Created by Денис Хафизов on 12.11.2023.
//

import Foundation

struct Pokemon: Decodable {
    let results: [PokemonList]?
}

struct PokemonList: Decodable {
    let name: String?
}
