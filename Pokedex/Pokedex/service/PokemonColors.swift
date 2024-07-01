//
//  PokemonColors.swift
//  Pokedex
//
//  Created by Jonrel Baclayon on 6/30/24.
//

import Foundation
import SwiftUI

class PokemonColors: ObservableObject {
    static let shared = PokemonColors()
    
    func colorForPokemonType(type: String) -> Color {
        switch type.lowercased() {
            case "normal":
                return Color.gray
            case "fire":
                return Color.red
            case "water":
                return Color.blue
            case "electric":
                return Color.yellow
            case "grass":
                return Color.green
            case "ice":
                return Color.cyan
            case "fighting":
                return Color.orange
            case "poison":
                return Color.purple
            case "ground":
                return Color.brown
            case "flying":
                return Color.cyan
            case "psychic":
                return Color.pink
            case "bug":
                return Color.green
            case "rock":
                return Color.gray
            case "ghost":
                return Color.purple
            case "dragon":
                return Color.blue
            case "dark":
                return Color.black
            case "steel":
                return Color.gray
            case "fairy":
                return Color.pink
            default:
                return Color.gray // Default color for unknown types
        }
    }
}
