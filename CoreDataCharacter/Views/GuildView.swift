import SwiftUI
import CoreData

import SwiftUI

struct GuildView: View  {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    // Busca de Guildas com o Core Data
    @FetchRequest(entity: Guild.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Guild.name, ascending: true)])
    var guilds:  FetchedResults<Guild>
    
    // Disponibiliza a modal na página
    @State private var mostrarAlerta = false
    
    // Variável para guardar o nome da Guilda
    @State private var novoNomeGuilda = ""
    
    var body: some View {
        // Optei pelo navigationStack padrão por falta de tempo e disposição para aprender direitinho como funcionava o navigationPath
        NavigationStack {
            List {
                // Esse ForEach está fazendo com que o NavigationLing leve o usuário para a próxima tela passando a guilda como valor
                ForEach(guilds) { guild in
                    NavigationLink(value: guild) {
                        Text(guild.name ?? "Guilda sem nome")
                    }
                }.onDelete(perform: deleteGuild)
            }.navigationTitle("Guildas")
            // Quando um NavigationLink é ativado, o item abaixo informa o que deve ser feito para haver a navegação da tela
                .navigationDestination(for: Guild.self) { guild in
                    CharacterView(guild: guild)
                }
            // Configura a toolbar acima do NavigationTitle da página, com o + para adicionar mais guildas.
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            mostrarAlerta = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $mostrarAlerta) {
                    // Apresenta a modal, se eu não passar o managedObjectContext para o novo arquivo ele não salva os dados, por isso eu chamei o banco só lá.
                    AddGuildSheetView()
                        .environment(\.managedObjectContext, self.managedObjectContext)
                }
        }
    }
    
    private func deleteGuild(at offsets: IndexSet) {
            for index in offsets {
                let guild = guilds[index]
                managedObjectContext.delete(guild)
            }
            try? managedObjectContext.save()
        }
    
}

#Preview {
    GuildView()
}
