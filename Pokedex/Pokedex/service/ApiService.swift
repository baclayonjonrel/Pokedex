//
//  ApiService.swift
//  Pokedex
//
//  Created by Jonrel Baclayon on 6/29/24.
//

import Foundation

class ApiService: ObservableObject {
    // Create a static shared instance
    static let shared = ApiService()
    
    @Published var fetchedPokemons: [Result] = []
    @Published var favoritePokemons: [Result] = []
    
    private init() {
        // Private initializer to prevent multiple instances
    }
    
    func getPokemons(completionHandler: @escaping ((Bool) -> Void)) {
        let urlString = "https://pokeapi.co/api/v2/pokemon?limit=100&offset=0"
        guard let url = URL(string: urlString) else {
            completionHandler(false)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching Pokemons: \(error.localizedDescription)")
                completionHandler(false)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Unexpected response: \(String(describing: response))")
                completionHandler(false)
                return
            }
            
            if let data = data {
                do {
                    var pokemonList = try JSONDecoder().decode(Pokemon.self, from: data)
                    print("Successfully fetched Pokémon list")
                    
                    // Here, we'll iterate through pokemonList results and fetch details for each Pokemon
                    var successful = true
                    let dispatchGroup = DispatchGroup()
                    
                    for index in pokemonList.results.indices {
                        let result = pokemonList.results[index]
                        self.fetchedPokemons = pokemonList.results
                        
                        dispatchGroup.enter()
                        // Assuming `fetchPokemonDetails` is a method that fetches Pokemon details
                        self.fetchPokemonDetails(url: result.url) { details in
                            guard let details = details else {
                                dispatchGroup.leave()
                                return
                            }

                            self.fetchedPokemons[index].details = details
                            dispatchGroup.leave()
                        }

                    }
                    
                    dispatchGroup.notify(queue: .main) {
                        // Replace the original pokemonList with updated results
                        
                        completionHandler(true)
                    }
                    
                } catch {
                    print("Failed to decode JSON: \(error.localizedDescription)")
                    completionHandler(false)
                }
            } else {
                print("No data received")
                completionHandler(false)
            }
        }
        
        task.resume()
    }


    private func fetchPokemonDetails(url: String, completion: @escaping (PokemonDetails?) -> Void) {
        guard let url = URL(string: url) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching Pokemon details: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Unexpected response when fetching Pokemon details: \(String(describing: response))")
                completion(nil)
                return
            }
            
            if let data = data {
                do {
                    // Print JSON response as a string
//                    if let jsonString = String(data: data, encoding: .utf8) {
//                        print("JSON Response: \(jsonString)")
//                    }

                    let pokemonDetails = try JSONDecoder().decode(PokemonDetails.self, from: data)
                    completion(pokemonDetails)
                } catch {
                    print("Failed to decode Pokemon details JSON: \(error.localizedDescription)")
                    completion(nil)
                }
            } else {
                print("No data received when fetching Pokemon details")
                completion(nil)
            }
        }.resume()
    }

    func isFavoritePokemon(pokemon: Result) -> Bool {
        for favoritePokemon in favoritePokemons {
            print(favoritePokemon.name)
        }
        if favoritePokemons.contains(where: { $0.name == pokemon.name }) {
            return true
        } else {
            return false
        }
    }

}
