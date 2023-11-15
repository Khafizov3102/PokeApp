//
//  Pokemon.swift
//  PokeApp
//
//  Created by Денис Хафизов on 12.11.2023.
//

import Foundation

struct PokemonApp: Decodable {
    let results: [Pokemon]?
}

struct Pokemon: Decodable {
    let name: String?
    let url: String?
}

struct Specifications: Decodable {
    let height: Int?
    let sprites: Sprites?
    let stats: [Stats]?
    let weight: Int?
}

struct Sprites: Decodable {
    let other: Home?
}

struct Home: Decodable {
    let home: FrontImage?
}

struct FrontImage: Decodable {
    let front_default: String?
}

struct Stats: Decodable {
    let base_stat: Int?
    let stat: Stat?
}

struct Stat: Decodable {
    let name: String?
}
