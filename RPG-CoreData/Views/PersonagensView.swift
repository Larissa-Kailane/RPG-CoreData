//
//  PersonagensView.swift
//  RPG-CoreData
//
//  Created by Paulo Henrique Costa Alves on 03/07/25.
//

import SwiftUI

struct PersonagensView: View {
    @Environment(\.managedObjectContext) var viewContext

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Character.name, ascending: true)], animation: .default)
    var characters: FetchedResults<Character>
    
    @State private var showingCreate = false
    
    var body: some View {
        List {
            if characters.isEmpty {
                Text("Nenhum personagem aqui.")
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
            PersonagensDetailView()
            .environment(\.managedObjectContext, viewContext)
        }
    }

    
    func deleteCharacters(at offsets: IndexSet) {
        offsets.forEach { index in
            let character = characters[index]
            viewContext.delete(character)
        }
        do {
            try viewContext.save()
            print("Personagem apagado do banco.")
        } catch {
            print("Erro ao salvar após deletar: \(error.localizedDescription)")
        }
        
    }
}

#Preview {
    PersonagensView()
}
