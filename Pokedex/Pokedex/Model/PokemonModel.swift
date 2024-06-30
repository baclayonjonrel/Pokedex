//
//  PokemonModel.swift
//  Pokedex
//
//  Created by Jonrel Baclayon on 6/29/24.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let pokemon = try? JSONDecoder().decode(Pokemon.self, from: jsonData)

import Foundation

// MARK: - Pokemon
struct Pokemon: Codable {
    let results: [Result]
}

// MARK: - Result
struct Result: Codable, Identifiable {
    var id = UUID()
    
    let name: String
    let url: String
    var details: PokemonDetails?

    enum CodingKeys: String, CodingKey, Codable {
        case name, url
        case details
    }
}
