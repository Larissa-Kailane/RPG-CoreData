//
//  SwiftUIView.swift
//  CoreDataCharacter
//
//  Created by Micael Martins de Moura on 03/07/25.
//

import SwiftUI

struct AddGuildSheetView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    // Chamando o dismiss para conseguir fechar a modal
    @Environment(\.dismiss) var dismiss
    
    // State para guardar o nome da guilda
    @State private var guildName = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Nome da Guilda", text: $guildName)
            }
            .navigationTitle("Nova Guilda")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // botão de cancelar
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Salvar") {
                        // Esqueminha para criar a guilda no contexto do CoreData
                        let newGuild = Guild(context: managedObjectContext)
                        newGuild.name = guildName
                        newGuild.id = UUID() // Estamos usando ID, então isso aqui é necessário também.
                        
                        //tenta salvar sem considerar a possibilidade de Crashs
                        try? managedObjectContext.save()
                        
                        //Por último fecha a modal
                        dismiss()
                    }
                    // O Gemini deu a sugestão de ser impossível de salvar se o nome não estivesse preenchido, gostei da ideia.
                    .disabled(guildName.isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddGuildSheetView()
}
