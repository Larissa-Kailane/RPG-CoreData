//
//  GuildView.swift
//  RPG-CoreData
//
//  Created by Larissa Kailane on 02/07/25.
//

import SwiftUI

import SwiftUI

// Modelo simples de Guilda
struct GuildModel: Identifiable {
    let id: UUID
    let name: String
}

struct GuildView: View {
    
    // Duas guildas pré-definidas
    let guilds: [GuildModel] = [
        GuildModel(id: UUID(), name: "Ordem dos bits"),
        GuildModel(id: UUID(), name: "Clã dos dados")
    ]
    
    var body: some View {
        NavigationStack {
            List(guilds) { guild in
                NavigationLink {
                    // Quando clica, vai para a tela dos personagens da guilda
                    CharacterView(guildName: guild.name)
                } label: {
                    Text(guild.name)
                        .font(.headline)
                        .padding(.vertical, 8)
                }
            }
            .navigationTitle("Guildas")
        }
    }
}

#Preview {
    GuildView()
}
