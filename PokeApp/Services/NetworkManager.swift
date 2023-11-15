//
//  NetworkManager.swift
//  PokeApp
//
//  Created by Денис Хафизов on 15.11.2023.
//

import Foundation

enum Link: String {
    case url = "https://pokeapi.co/api/v2/pokemon?limit=20&offset=0"
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetch<T: Decodable>(type: T.Type, from url: String, comletion: @escaping(Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            comletion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data else {
                comletion(.failure(.noData))
                return
            }
            
            do {
                let type = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    comletion(.success(type))
                }
            } catch {
                comletion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func fetchImage(url: String, completion: @escaping(Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                completion(.failure(.decodingError))
                return
            }
            DispatchQueue.main.async {
                completion(.success(imageData))
            }
        }
    }
}
