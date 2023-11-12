//
//  ViewController.swift
//  PokeApp
//
//  Created by Денис Хафизов on 12.11.2023.
//

import UIKit

enum Alert {
    case success
    case failed
    
    var title: String {
        switch self {
        case .success:
            return "Success"
        case .failed:
            return "Failed"
        }
    }
    
    var message: String {
        switch self {
        case .success:
            return "You can see the result in the Debug area."
        case .failed:
            return "You can see error in the Debug area."
        }
    }
}

class MainViewController: UIViewController {
    
    let link = "https://pokeapi.co/api/v2/pokemon?limit=20&offset=0"

    @IBAction func showPokemonButtonPressed() {
        fetchPokemon()
    }
    
    private func fetchPokemon() {
        guard let url = URL(string: link) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let pokemon = try JSONDecoder().decode(Pokemon.self, from: data)
                self.showAlert(status: .success)
                print(pokemon.results ?? "")
            } catch {
                print(error.localizedDescription)
                self.showAlert(status: .failed)
            }
            
        }.resume()
    }
    private func showAlert(status: Alert) {
        let alert = UIAlertController(title: status.title, message: status.message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        
        DispatchQueue.main.async { [unowned self] in
            present(alert, animated: true)
        }
    }
}

