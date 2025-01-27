//
//  PokemonScrollView.swift
//  Pokedex
//
//  Created by Jonrel Baclayon on 6/30/24.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct PokemonGridView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State var pokemonList: [Result] = []
    @ObservedObject var apiService = ApiService.shared
    @State private var pokemonIndexRemove: Int = -1
    @State private var showDetailView = false
    @State private var selectedPokemon: Result = Result(name: "", url: "", details: nil)
    @State private var selectedIndex: Int = -1
    @State private var showConf = false
    
    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height
            let columns: [GridItem] = {
                if horizontalSizeClass != .compact || isLandscape {
                    return [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ]
                } else {
                    return [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ]
                }
            }()
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 30) {
                    ForEach(pokemonList.indices, id: \.self) { index in
                        if pokemonList[index].details != nil {
                            PokemonGridCard(pokemon: pokemonList[index])
                                .onTapGesture {
                                    withAnimation {
                                        showDetailView.toggle()
                                    }
                                    apiService.setSelectedPokemon(pokemonList[index])
                                }
                        } else {
                            EmptyView()
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $showDetailView) {
                if let selectedPokemon = apiService.selectedPokemon {
                    NavigationView {
                        PokemonDetailView(pokemon: selectedPokemon)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button {
                                        if apiService.isFavoritePokemon(pokemon: selectedPokemon) {
                                            if let selectedIndex = apiService.favoritePokemons.firstIndex(where: { $0.name == selectedPokemon.name }) {
                                                pokemonIndexRemove = selectedIndex
                                                showConf.toggle()
                                            }
                                        } else {
                                            if !apiService.favoritePokemons.contains(where: { $0.name ==  selectedPokemon.name }) {
                                                apiService.favoritePokemons.append(selectedPokemon)
                                            }
                                        }
                                    } label: {
                                        Image(systemName: apiService.isFavoritePokemon(pokemon: selectedPokemon) ? "star.fill" : "star")
                                    }
                                    .actionSheet(isPresented: $showConf) {
                                        ActionSheet(
                                            title: Text("Remove from favorites?"),
                                            buttons: [
                                                .cancel(), .destructive(Text("Yes"), action: {
                                                    print("Deleting...")
                                                    if pokemonIndexRemove >= 0 {
                                                        apiService.favoritePokemons.remove(at: pokemonIndexRemove)
                                                    }
                                                })
                                            ]
                                        )
                                    }
                                }
                            }
                    }
                }
            }
        }
    }
}

struct PokemonGridCard: View {
    let pokemon: Result
    

    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                VStack {
                    Rectangle()
                        .opacity(0)
                        .frame(height: 50)
                    WaterShape()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)),Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .ignoresSafeArea()
                }
                
                VStack(alignment: .leading) {
                    Text(pokemon.name.lowercased().capitalized)
                        .font(.headline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 0)
                    Spacer()
                }
                
                let imageURL = pokemon.details?.sprites?.other?.officialArtwork?.frontShiny ?? ""
                VStack {
                    Spacer()
                    WebImage(url: URL(string: imageURL))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 140, height: 130)
                }
                VStack {
                    Spacer()
                    HStack {
                        if let types = pokemon.details?.types {
                            ForEach(types, id: \.self) { typeElement in
                                if let typeName = typeElement.type?.name {
                                    let backgroundColor = PokemonColors.shared.colorForPokemonType(type: typeName.lowercased())
                                    
                                    Text(typeName)
                                        .font(.system(size: 10))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 4)
                                        .padding(.vertical, 2)
                                        .background(backgroundColor)
                                        .cornerRadius(4)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 4)
                }
            }
            .background(PokemonColors.shared.colorForPokemonType(type: pokemon.details?.types?.first?.type?.name ?? "").opacity(0.8))
            .cornerRadius(16)
            .frame(width: 150, height: 150)
        }
    }
}

struct PokemonListView: View {
    
    @State var pokemonList: [Result] = []
    
    var body: some View {
        VStack {
            ScrollView {
                    ForEach(pokemonList.indices, id: \.self) { index in
                        if pokemonList[index].details != nil {
                            PokemonListCard(pokemon: pokemonList[index])
                                .padding(5)
                        } else {
                            EmptyView()
                        }
                    }
            }
        }
    }
}

struct PokemonListCard: View {
    let pokemon: Result
    @State private var showDetailView = false
    @ObservedObject var apiService = ApiService.shared
    @State private var pokemonIndexRemove = -1
    
    @State var showConf = false
    
    var body: some View {
        HStack {
            ZStack {
                VStack {
                    Rectangle()
                        .opacity(0)
                        .frame(height: 50)
                    WaterShape()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)),Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .ignoresSafeArea()
                }
                
                let imageURL = pokemon.details?.sprites?.other?.officialArtwork?.frontShiny ?? ""
                VStack {
                    Spacer()
                    WebImage(url: URL(string: imageURL))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            .background(PokemonColors.shared.colorForPokemonType(type: pokemon.details?.types?.first?.type?.name ?? "").opacity(0.8))
            .cornerRadius(16)
            .frame(width: 90, height: 90)
            .padding(5)
            
            VStack {
                HStack {
                    Text(pokemon.name.lowercased().capitalized)
                        .font(.headline)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 0)
                    Spacer()
                }
                HStack {
                    if let types = pokemon.details?.types {
                        ForEach(types, id: \.self) { typeElement in
                            if let typeName = typeElement.type?.name {
                                //let backgroundColor = colorForPokemonType(type: typeName.lowercased())
                                let backgroundColor = PokemonColors.shared.colorForPokemonType(type: typeName.lowercased())
                                Text(typeName)
                                    .font(.system(size: 10))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 2)
                                    .background(backgroundColor)
                                    .cornerRadius(4)
                            }
                        }
                        Spacer()
                    }
                }
                .padding(.bottom, 4)
            }
        Spacer()
        }
        .background(.gray.opacity(0.3))
        .cornerRadius(10)
        .padding(.horizontal, 5)
        .onTapGesture {
            showDetailView.toggle()
        }
        .fullScreenCover(isPresented: $showDetailView) {
            NavigationView {
                PokemonDetailView(pokemon: pokemon)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                if apiService.isFavoritePokemon(pokemon: pokemon) {
                                    if let index = apiService.favoritePokemons.firstIndex(where: { $0.name == pokemon.name }) {
                                        pokemonIndexRemove = index
                                        showConf.toggle()
                                    }
                                } else {
                                    if !apiService.favoritePokemons.contains(where: { $0.name == pokemon.name }) {
                                        apiService.favoritePokemons.append(pokemon)
                                    }
                                }
                            } label: {
                                Image(systemName: apiService.isFavoritePokemon(pokemon: pokemon) ? "star.fill" : "star")
                            }
                            .actionSheet(isPresented: $showConf) {
                              ActionSheet(
                                title: Text("Remove from favorites?"),
                                buttons: [
                                  .cancel(), .destructive(Text("Yes"), action: {
                                    print("Deleting...")
                                      if pokemonIndexRemove >= 0 {
                                          apiService.favoritePokemons.remove(at: pokemonIndexRemove)
                                      }
                                  })
                                ]
                              )
                            }
                        }
                    }
            }
        }
    }
}



