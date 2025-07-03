
//
//  CharacterView.swift
//  RPG-CoreData
//
//  Created by Larissa Kailane on 01/07/25.
//


import SwiftUI
import CoreData

struct CharacterView: View {
    @Environment(\.managedObjectContext) var viewContext
    
    let guild: Guild
    
    @FetchRequest var characters: FetchedResults<Character>
    
    @State private var showingCreate = false
    
    // Novo init que aceita Guild
    init(guild: Guild) {
        self.guild = guild
        // Monta o fetch request com a predicate
        _characters = FetchRequest(
            entity: Character.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Character.name, ascending: true)
            ],
            predicate: NSPredicate(format: "guild == %@", guild)
        )
    }
    
    var body: some View {
        List {
            if characters.isEmpty {
                Text("Nenhum personagem nesta guilda.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(characters, id: \.self) { character in
                    VStack(alignment: .leading) {
                        Text(character.title ?? "Sem título")
                            .font(.headline)
                        Text(character.name ?? "Sem nome")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("Idade: \(character.age) anos")
                            .font(.footnote)
                        
                        if let powerName = character.power?.name {
                            Text("Poder: \(powerName)")
                                .font(.footnote)
                        }
                        
                        if let items = character.items as? Set<Item>, !items.isEmpty {
                            Text("Itens: \(items.map { $0.name ?? "Sem nome" }.joined(separator: ", "))")
                                .font(.footnote)
                        }
                    }
                }.onDelete(perform: deleteCharacters)
            }
        }
        .navigationTitle(guild.name ?? "Sem nome")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingCreate = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingCreate) {
            CharacterDetailView(
                guild: guild,
                character: nil
            )
            .environment(\.managedObjectContext, viewContext)
        }
    }

    
    func deleteCharacters(at offsets: IndexSet) {
        offsets.forEach { index in
            let character = characters[index]
            viewContext.delete(character)
        }
        
    }
}
