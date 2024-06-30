//
//  FavoriteView.swift
//  Pokedex
//
//  Created by Jonrel Baclayon on 6/30/24.
//

import Foundation
import SwiftUI

struct FavoriteView: View {
    
    @State var pokemonList: [Result] = []
    @State var isGridView: Bool = true
    @ObservedObject var apiService = ApiService.shared
    
    var body: some View {
        VStack {
            if apiService.favoritePokemons.isEmpty {
                Text("No pokemons are added yet.")
            } else {
                if isGridView {
                    PokemonGridView(pokemonList: apiService.favoritePokemons)
                        .frame(maxHeight: UIScreen.main.bounds.height)
                } else {
                    PokemonListView(pokemonList: apiService.favoritePokemons)
                        .frame(maxHeight: UIScreen.main.bounds.height)
                }
            }
        }
        .id(UUID())
        .padding()
        .navigationTitle("Favorites")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isGridView.toggle()
                }) {
                    Image(systemName: isGridView ? "list.bullet" : "rectangle.grid.2x2")
                        .renderingMode(.template)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
