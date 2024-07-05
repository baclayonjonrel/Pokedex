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
    @State var showSearchView: Bool = false
    
    var body: some View {
        VStack {
            if !hasFetchedPokemon {
                ProgressView("Loading Pokemons...")
            } else {
                if isGridView {
                    PokemonGridView(pokemonList: pokemonList)
                } else {
                    PokemonListView(pokemonList: pokemonList)
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
                HStack {
                    Button(action: {
                        showSearchView.toggle()
                    }) {
                        Image(systemName: "magnifyingglass")
                            .renderingMode(.template)
                    }
                    Button(action: {
                        isGridView.toggle()
                    }) {
                        Image(systemName: isGridView ? "list.bullet" : "rectangle.grid.2x2")
                            .renderingMode(.template)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $showSearchView) {
            NavigationStack {
                SearchView()
            }
        }
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
