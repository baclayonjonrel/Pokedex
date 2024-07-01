//
//  PokemonModel.swift
//  Pokedex
//
//  Created by Jonrel Baclayon on 6/29/24.

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
