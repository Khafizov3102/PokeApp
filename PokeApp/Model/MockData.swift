//
//  MockData.swift
//  PokeApp
//
//  Created by Денис Хафизов on 06.11.2024.
//

import Foundation

final class MockData {
    static func createMockData<T>(for type: T.Type) -> Any {
        if type == PokemonApp.self {
            return PokemonApp(results: [
                Pokemon(name: "Bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"),
                Pokemon(name: "Charmander", url: "https://pokeapi.co/api/v2/pokemon/4/"),
                Pokemon(name: "Squirtle", url: "https://pokeapi.co/api/v2/pokemon/7/")
            ])
        } else if type == Specifications.self {
            return Specifications(
                height: 7,
                sprites: Sprites(
                    other: Home(
                        home: FrontImage(
                            front_default: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/1.png"
                        )
                    )
                ),
                stats: [
                    Stats(base_stat: 45, stat: Stat(name: "HP")),
                    Stats(base_stat: 49, stat: Stat(name: "Attack")),
                    Stats(base_stat: 49, stat: Stat(name: "Defense"))
                ],
                weight: 69
            )
        }
        return PokemonApp(results: [])
    }
    
    static func createMockImageURL() -> URL? {
            return URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/1.png")
        }
}
