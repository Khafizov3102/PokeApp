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
    
    var simulateError: Bool = false  // Флаг для симуляции ошибки
    var isMockingEnabled: Bool = false  // Флаг для включения мок-данных
    
    func fetch<T: Decodable>(type: T.Type, from url: String, completion: @escaping(Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        
        if simulateError {
            completion(.failure(.noData))
            return
        }
        
        if isMockingEnabled {
            guard let mockData = MockData.createMockData(for: type) as? T else { return }
            completion(.success(mockData))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let type = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(type))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func fetchImage(url: String, completion: @escaping(Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        
        if simulateError {
            completion(.failure(.decodingError))
            return
        }
        
        if isMockingEnabled {
            guard let mockImageURL = MockData.createMockImageURL() else {
                completion(.failure(.decodingError))
                return
            }
            fetchImageFromURL(url: mockImageURL, completion: completion)
            return
        }
        
        fetchImageFromURL(url: url, completion: completion)
    }
    
    private func fetchImageFromURL(url: URL, completion: @escaping(Result<Data, NetworkError>) -> Void) {
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

