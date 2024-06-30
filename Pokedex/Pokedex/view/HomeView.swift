//
//  HomeView.swift
//  Pokedex
//
//  Created by Jonrel Baclayon on 6/30/24.
//

import Foundation
import SwiftUI

struct HomeView: View {
    
    @State var pokemonList: [Result] = []
    @State var hasFetchedPokemon: Bool = false
    @State var isGridView: Bool = true
    
    var body: some View {
        VStack {
            if !hasFetchedPokemon {
                ProgressView("Loading Pokemons...")
            } else {
                if isGridView {
                    PokemonGridView(pokemonList: pokemonList)
                        .frame(maxHeight: UIScreen.main.bounds.height)
                } else {
                    PokemonListView(pokemonList: pokemonList)
                        .frame(maxHeight: UIScreen.main.bounds.height)
                }
            }
        }
        .padding()
        .onAppear() {
            if !hasFetchedPokemon {
                fetchPokemons()
            }
        }
        .navigationTitle("Home")
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
    func fetchPokemons() -> Void {
        ApiService.shared.getPokemons { res in
            if res {
                pokemonList = ApiService.shared.fetchedPokemons
                hasFetchedPokemon = true
            }
        }
    }
    
}
