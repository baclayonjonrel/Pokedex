//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by Jonrel Baclayon on 7/1/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct PokemonDetailView: View {
    let pokemon: Result
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedSegment = 0
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                let isLandscape = geometry.size.width > geometry.size.height
                if !isLandscape {
                    CurveShape()
                        .fill(PokemonColors.shared.colorForPokemonType(type: pokemon.details?.types?.first?.type?.name ?? "").opacity(0.7))
                        .ignoresSafeArea(.all)
                        .offset(y: horizontalSizeClass != .compact ? -150 : 0)
                    
                    
                    VStack {
                        Text(pokemon.name.uppercased())
                            .font(.system(size: 55))
                            .fontWeight(.bold)
                        
                        HStack {
                            if let types = pokemon.details?.types {
                                ForEach(types, id: \.self) { typeElement in
                                    if let typeName = typeElement.type?.name {
                                        let backgroundColor = PokemonColors.shared.colorForPokemonType(type: typeName.lowercased())
                                        
                                        Text(typeName)
                                            .font(.system(size: 15))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 4)
                                            .padding(.vertical, 2)
                                            .background(backgroundColor)
                                            .cornerRadius(4)
                                    }
                                }
                            }
                        }
                        ZStack {
                            let imageURL = pokemon.details?.sprites?.other?.officialArtwork?.frontShiny ?? pokemon.details?.sprites?.other?.officialArtwork?.frontDefault ?? ""
                            WebImage(url: URL(string: imageURL))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200)
                        }
                        Picker("Select a tab", selection: $selectedSegment) {
                            Text("About").tag(0)
                            Text("Base Stats").tag(1)
                            if pokemon.details?.heldItems?.count != 0{
                                Text("Evolution").tag(2)
                            }
                            Text("Moves").tag(3)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        if selectedSegment == 0 {
                            AboutPokemonView(pokemon: pokemon)
                        } else if selectedSegment == 1 {
                            BaseStatsView(pokemon: pokemon)
                        } else if selectedSegment == 2 {
                            HeldItemView(pokemon: pokemon)
                        } else if selectedSegment == 3 {
                            MovesView(pokemon: pokemon)
                        }
                        Spacer()
                    }
                } else {
                    HStack {
                        VStack {
                            Text(pokemon.name.uppercased())
                                .font(.system(size: 35))
                                .fontWeight(.bold)
                            
                            HStack {
                                if let types = pokemon.details?.types {
                                    ForEach(types, id: \.self) { typeElement in
                                        if let typeName = typeElement.type?.name {
                                            let backgroundColor = PokemonColors.shared.colorForPokemonType(type: typeName.lowercased())
                                            
                                            Text(typeName)
                                                .font(.system(size: 15))
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 4)
                                                .padding(.vertical, 2)
                                                .background(backgroundColor)
                                                .cornerRadius(4)
                                        }
                                    }
                                }
                            }
                            let imageURL = pokemon.details?.sprites?.other?.officialArtwork?.frontShiny ?? ""
                            WebImage(url: URL(string: imageURL))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200)
                        }
                        Spacer()
                        VStack {
                            Picker("Select a tab", selection: $selectedSegment) {
                                Text("About").tag(0)
                                Text("Base Stats").tag(1)
                                if pokemon.details?.heldItems?.count != 0{
                                    Text("Evolution").tag(2)
                                }
                                Text("Moves").tag(3)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            if selectedSegment == 0 {
                                AboutPokemonView(pokemon: pokemon)
                            } else if selectedSegment == 1 {
                                BaseStatsView(pokemon: pokemon)
                            } else if selectedSegment == 2 {
                                HeldItemView(pokemon: pokemon)
                            } else if selectedSegment == 3 {
                                MovesView(pokemon: pokemon)
                            }
                        }
                        Spacer()
                    }
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
}

struct AboutPokemonView: View {
    
    let pokemon: Result
    
    var body: some View {
        HStack {
            VStack (alignment: .leading) {
                List {
                    Section("Physical") {
                        HStack {
                            Text("Species:")
                            Spacer()
                            Text(pokemon.details?.species?.name ?? "No Value")
                        }
                        HStack {
                            Text("Height:")
                            Spacer()
                            Text(String(pokemon.details?.height ?? 0))
                        }
                        HStack {
                            Text("Weight:")
                            Spacer()
                            Text(String(pokemon.details?.weight ?? 0))
                        }
                    }
                    Section ("Abilities") {
                        if let abilities = pokemon.details?.abilities {
                            
                                ForEach((0..<abilities.count), id: \.self) {index in
                                    Text("\(abilities[index].ability?.name?.lowercased().capitalized ?? "")")
                                }
                            
                        } else {
                            Text("No Abilities")
                        }
                    }
                }
            }
            .ignoresSafeArea(.all)
        }
    }
}

struct BaseStatsView: View {
    
    let pokemon: Result
    
    var body: some View {
        HStack {
            VStack (alignment: .leading) {
                List {
                    if let stats = pokemon.details?.stats {
                        ForEach((0..<stats.count), id: \.self) {index in
                            HStack {
                                Text(stats[index].stat?.name?.capitalized ?? "")
                                Spacer()
                                ProgressView(value: Double(stats[index].baseStat ?? 0), total: 100)
                                    .tint(Double(stats[index].baseStat ?? 0) > 60 ? .green : .orange)
                                }
                            }
                    } else {
                        Text("No Stats Available")
                    }
                }
            }
        }
        .ignoresSafeArea(.all)
    }
}

struct HeldItemView: View {
    
    let pokemon: Result
    
    var body: some View {
        HStack {
            VStack (alignment: .leading) {
                if let items = pokemon.details?.heldItems {
                    ForEach((0..<items.count), id: \.self) {index in
                        VStack {
                            HStack {
                                Text(items[index].item?.name ?? "")
                            }
                            if let versionDetails = items[index].versionDetails {
                                List {
                                    Section(header: Text("Versions")) {
                                        ForEach((0..<versionDetails.count), id: \.self) {index1 in
                                            HStack {
                                                Text(versionDetails[index1].version?.name?.capitalized ?? "")
                                                Spacer()
                                                Text("Rarity: \(String(versionDetails[index1].rarity ?? 0))")
                                                    .foregroundStyle(Color.gray)
                                            }
                                    }
                                    }
                                }
                            
                            } else {
                                Text("No Versions Available")
                            }
                        }
                    }
                } else {
                    Text("No Stats Available")
                }
            }
        }
        .ignoresSafeArea(.all)
        .onAppear() {
            let items = pokemon.details?.heldItems
        }
        .background(.background)
    }
}

struct MovesView: View {
    
    let pokemon: Result
    
    var body: some View {
        HStack {
            VStack (alignment: .leading) {
                if let moves = pokemon.details?.moves {
                    HStack {
                        Text("Name")
                        Spacer()
                        Text("Level Learned")
                        Spacer()
                        Text("Learn Method")
                    }
                    .padding(.horizontal, 20)
                    List {
                        ForEach((0..<moves.count), id: \.self) { index in
                            HStack {
                                Text(moves[index].move?.name ?? "")
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)

                                Text(String(moves[index].versionGroupDetails?.first?.levelLearnedAt ?? 0))
                                    .frame(width: 30, alignment: .trailing)

                                Text(moves[index].versionGroupDetails?.first?.moveLearnMethod?.name ?? "")
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                            }


                        }
                    }
                } else {
                    Text("No Stats Available")
                }
            }
            .ignoresSafeArea(.all)
        }
        .background(.background)
    }
}

