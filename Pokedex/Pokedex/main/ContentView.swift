//
//  ContentView.swift
//  Pokedex
//
//  Created by Jonrel Baclayon on 6/29/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedIndex: Int = 0
    @ObservedObject var apiService = ApiService.shared
    
    var body: some View {
        TabView(selection: $selectedIndex) {
                NavigationStack() {
                    HomeView()
                }
                .tabItem {
                    Text("Home")
                    Image(systemName: "house.fill")
                        .renderingMode(.template)
                }
                .tag(0)
                
                NavigationStack() {
                    FavoriteView()
                }
                .tabItem {
                    Label("Favorites", systemImage: "star")
                }
                .badge("\(apiService.self.favoritePokemons.count)")
                .tag(1)
                
                NavigationStack() {
                    AboutView()
                        .navigationTitle("About")
                    
                }
                .tabItem {
                    Text("About")
                    Image(systemName: "info.circle")
                }
                .tag(2)
            }
            //1
            .tint(.blue)
            .onAppear(perform: {
                //2
                UITabBar.appearance().unselectedItemTintColor = .black
                //3
                UITabBarItem.appearance().badgeColor = .systemPink
                //4
                UITabBar.appearance().backgroundColor = .systemGray2.withAlphaComponent(0.5)
                //5
                UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.systemPink]
                UITabBar.appearance().scrollEdgeAppearance = UITabBarAppearance()
                //Above API will kind of override other behaviour and bring the default UI for TabView
            })
    }
}

#Preview {
    ContentView()
}
