//
//  MianTableViewController.swift
//  PokeApp
//
//  Created by Денис Хафизов on 15.11.2023.
//

import UIKit

final class MainTableViewController: UITableViewController {
    var pokemons: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 128
        fetchPokemon()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            guard let pokemonInfoVC = segue.destination as? PokemonInfoViewController else { return }
            pokemonInfoVC.pokemonName = pokemons[indexPath.row].name ?? ""
            pokemonInfoVC.url = pokemons[indexPath.row].url ?? ""
            pokemonInfoVC.pokemonIndex = indexPath.row
        }
    }
    
    private func fetchPokemon() {
        NetworkManager.shared.fetch(type: PokemonApp.self, from: Link.url.rawValue) { [unowned self] result in
            switch result {
            case .success(let pokemon):
                pokemons = pokemon.results ?? []
                tableView.reloadData()
            case .failure(let error):
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.showAlert(title: "Ошибка", message: error.localizedDescription)
                }
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

// MARK: - TableViewDataSource
extension MainTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pokemons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokeCell", for: indexPath)
        guard let cell = cell as? PokeCell else { return UITableViewCell() }
        
        let pokemon = pokemons[indexPath.row]
        cell.configure(pokemon: pokemon)

        return cell
    }
}
