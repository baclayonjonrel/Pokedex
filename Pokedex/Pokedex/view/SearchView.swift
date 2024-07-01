//
//  SearchView.swift
//  Pokedex
//
//  Created by Jonrel Baclayon on 7/1/24.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var pokemons = ApiService.shared.fetchedPokemons
    
    @Environment(\.presentationMode) var presentationMode

    var filteredPokemons: [Result] {
        if searchText.isEmpty {
            return pokemons.filter { $0.details?.types != nil }
        } else {
            return pokemons.filter { $0.name.lowercased().contains(searchText.lowercased()) && $0.details?.types != nil }
        }
    }

    var body: some View {
        VStack {
            List(filteredPokemons, id: \.id) { pokemon in
                PokemonListCard(pokemon: pokemon)
            }
            .listStyle(InsetGroupedListStyle())
        }
        .navigationTitle("Pokédex")
        .searchable(text: $searchText)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Label("Back", systemImage: "arrow.left.circle")
                }
            }
        }
    }
}
