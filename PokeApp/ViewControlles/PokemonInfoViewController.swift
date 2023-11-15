//
//  PokemonInfoViewController.swift
//  PokeApp
//
//  Created by Денис Хафизов on 15.11.2023.
//

import UIKit

final class PokemonInfoViewController: UIViewController {
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonImage: UIImageView!
    
    @IBOutlet weak var pokemonHeight: UILabel!
    @IBOutlet weak var pokemonWeight: UILabel!
    @IBOutlet weak var pokemonStats: UILabel!
    
    var pokemonName = ""
    var url = ""
    var pokemonIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonNameLabel.text = pokemonName
        fetchPokemonImage()
        fetchPokemonStats()
    }
    
    @IBAction func exitButtonPressed() {
        dismiss(animated: true)
    }
    
    private func fetchPokemonImage() {
        NetworkManager.shared.fetch(type: Specifications.self, from: url) { result in
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
    
    private func fetchPokemonStats() {
        NetworkManager.shared.fetch(type: Specifications.self, from: url) { [unowned self] result in
            switch result {
            case .success(let specifications):
                pokemonHeight.text = "Высота: " + String(Int(specifications.height ?? 0) * 10) + " см."
                pokemonWeight.text = "Вес: " + String(specifications.weight ?? 0) + " кг."
                pokemonStats.text = getStats(countOfStats: specifications.stats?.count ?? 0, stats: specifications.stats)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getStats(countOfStats: Int, stats: [Stats]?) -> String {
        var result = ""
        stats?.forEach({ stat in
            result += "\(stat.stat?.name ?? ""): \(stat.base_stat ?? 0) \n"
        })
        return result
    }
}
