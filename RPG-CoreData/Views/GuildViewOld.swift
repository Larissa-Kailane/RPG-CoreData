////
////  GuildView.swift
////  RPG-CoreData
////
////  Created by Larissa Kailane on 02/07/25.
////
//
//import SwiftUI
//
//import SwiftUI
//
//// Modelo simples de Guilda
//struct GuildModel: Identifiable {
//    let id: UUID
//    let name: String
//}
//
//struct GuildView: View {
//    @Environment(\.managedObjectContext) var viewContext
//
//    @FetchRequest(
//        entity: Guild.entity(),
//        sortDescriptors: [NSSortDescriptor(keyPath: \Guild.name, ascending: true)]
//    )
//    var guilds: FetchedResults<Guild>
//
//    var body: some View {
//        NavigationStack {
//            List(guilds, id: \.self) { guild in
//                NavigationLink {
//                    // Quando clica, vai para a tela dos personagens da guilda
//                    CharacterView(guild: guild)
//                } label: {
//                    Text(guild.name ?? "Sem nome")
//                        .font(.headline)
//                        .padding(.vertical, 8)
//                }
//            }
//            .navigationTitle("Guildas")
//        }
//    }
//}
//
//#Preview {
//    GuildView()
//}
