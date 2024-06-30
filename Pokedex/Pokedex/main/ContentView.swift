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
                .badge("12")
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
                UITabBar.appearance().backgroundColor = .systemGray4.withAlphaComponent(0.4)
                //5
                UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.systemPink]
                //UITabBar.appearance().scrollEdgeAppearance = UITabBarAppearance()
                //Above API will kind of override other behaviour and bring the default UI for TabView
            })
    }
}


///About
import SwiftUI
import WebKit

struct AboutView: View {
    var body: some View {
        ZStack {
            WebView(url: URL(string: "https://pokeapi.co/about")!)
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct WebView: UIViewRepresentable {
    let url: URL

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("Finished loading: \(webView.url?.absoluteString ?? "")")
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("Failed to load: \(error.localizedDescription)")
        }
    }
}
//About

#Preview {
    ContentView()
}
