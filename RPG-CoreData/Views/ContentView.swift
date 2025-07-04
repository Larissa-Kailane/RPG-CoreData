//
//  ContentView.swift
//  RPG-CoreData
//
//  Created by Paulo Henrique Costa Alves on 03/07/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack{
                GuildView()
                    .navigationTitle("Guilda")
            }
            .tabItem {
                Image(systemName: "person.crop.circle")
                Text("Guildas")
            }
            
            NavigationStack {
                PersonagensView()
                    .navigationTitle("Personagens")
            }
            .tabItem {
                Image(systemName: "person.2")
                Text("Personagens")
            }
        }
    }
}

#Preview {
    ContentView()
}
