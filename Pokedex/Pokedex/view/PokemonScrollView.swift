//
//  PokemonScrollView.swift
//  Pokedex
//
//  Created by Jonrel Baclayon on 6/30/24.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

let rows = [
        GridItem(.flexible())
    ]

struct PokemonGridView: View {
    
    @State var pokemonList: [Result] = []
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 30) {
                ForEach(pokemonList.indices, id: \.self) { index in
                    if pokemonList[index].details != nil {
                        PokemonGridCard(pokemon: pokemonList[index])
                    } else {
                        EmptyView()
                    }
                }
            }
        }
    }
}

struct PokemonGridCard: View {
    let pokemon: Result
    @State private var showDetailView = false
    @ObservedObject var apiService = ApiService.shared

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
                
                let imageURL = pokemon.details?.sprites?.frontShiny ?? pokemon.details?.sprites?.frontDefault ?? ""
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
                                    let backgroundColor = colorForPokemonType(type: typeName.lowercased())
                                    
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
            .background(colorForPokemonType(type: pokemon.details?.types?.first?.type?.name ?? "").opacity(0.8))
            .cornerRadius(16)
            .frame(width: 150, height: 150)
            .onTapGesture {
                print("selected: \(pokemon.name)")
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
                                            apiService.favoritePokemons.remove(at: index)
                                        }
                                    } else {
                                        // Check if the pokemon is already in the favoritePokemons list
                                        if !apiService.favoritePokemons.contains(where: { $0.name == pokemon.name }) {
                                            apiService.favoritePokemons.append(pokemon)
                                        }
                                    }
                                } label: {
                                    Image(systemName: apiService.isFavoritePokemon(pokemon: pokemon) ? "heart.fill" : "heart")
                                }
                            }
                        }
                }
            }
        }
    }
    
    private func colorForPokemonType(type: String) -> Color {
            switch type {
                case "fire":
                    return Color.red
                case "water":
                    return Color.blue
                case "grass":
                    return Color.green
                // Add more cases as needed
                default:
                    return Color.gray // Default color for unknown types
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
                
                let imageURL = pokemon.details?.sprites?.frontShiny ?? pokemon.details?.sprites?.frontDefault ?? ""
                VStack {
                    Spacer()
                    WebImage(url: URL(string: imageURL))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            .background(colorForPokemonType(type: pokemon.details?.types?.first?.type?.name ?? "").opacity(0.8))
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
                                let backgroundColor = colorForPokemonType(type: typeName.lowercased())

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
        .frame(width: UIScreen.main.bounds.width)
        .background(.gray.opacity(0.3))
        .cornerRadius(10)
        .padding(.horizontal, 5)
        .onTapGesture {
            print("selected: \(pokemon.name)")
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
                                        apiService.favoritePokemons.remove(at: index)
                                    }
                                } else {
                                    // Check if the pokemon is already in the favoritePokemons list
                                    if !apiService.favoritePokemons.contains(where: { $0.name == pokemon.name }) {
                                        apiService.favoritePokemons.append(pokemon)
                                    }
                                }
                            } label: {
                                Image(systemName: apiService.isFavoritePokemon(pokemon: pokemon) ? "heart.fill" : "heart")
                            }
                        }
                    }
            }
        }
    }
    
    private func colorForPokemonType(type: String) -> Color {
            switch type {
                case "fire":
                    return Color.red
                case "water":
                    return Color.blue
                case "grass":
                    return Color.green
                // Add more cases as needed
                default:
                    return Color.gray // Default color for unknown types
            }
        }
}

struct WaterShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.midY),
                              control: CGPoint(x: rect.width * 0.20, y: rect.height * 0.35))
            path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.midY),
                              control: CGPoint(x: rect.width * 0.80, y: rect.height * 0.65))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        }
    }
}


struct PokemonDetailView: View {
    let pokemon: Result
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Pokemon name: \(pokemon.name)")
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
               Text("Close FullScreen")
            }
        }
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
