//
//  PokeCell.swift
//  PokeApp
//
//  Created by Денис Хафизов on 15.11.2023.
//

import UIKit

final class PokeCell: UITableViewCell {
    
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var pokemonNameLabel: UILabel!
        
    func configure(pokemon: Pokemon) {
        pokemonNameLabel.text = pokemon.name
        fetchPokemonImage(pokemon: pokemon)
    }
    
    private func fetchPokemonImage(pokemon: Pokemon) {
        NetworkManager.shared.fetch(type: Specifications.self, from: pokemon.url ?? "") { result in
            switch result {
            case .success(let specifications):
                NetworkManager.shared.fetchImage(url: specifications.sprites?.other?.home?.front_default ?? "") { [unowned self] result in
                    switch result {
                    case .success(let data):
                        pokemonImage.image = UIImage(data: data)
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
