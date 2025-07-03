import SwiftUI
import CoreData

import SwiftUI

struct CharacterView: View  {
    
    // Toda página de início deve ter esses dois
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.coreDataManager) private var coordinator
    // O viewContext para o contexto do banco
    // O coordinator para funções personalizadas do Manager.
    
    // Aqui vai buscar as guildas por ID
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Guild.id, ascending: true)], animation: .default)
    // Salva o resultado do fetch nessa variável
    private var guilds: FetchedResults<Guild>
    
    // Aqui, essa variável é para mostrar o modal ou não
    @State private var showAddScreen = false
    // Essa é para podermos diferenciar quando é uma edição e quando é uma adição de nova guilda.
    @State private var editGuild: Guild?
    
    var body: some View {
        NavigationStack {
            // Listagem de Guildas
            List {
                // For para cada guilda
                ForEach(guilds, id: \.id) { guild in
                    // aqui o button na listagem ao invés de só um text, pois agora com o click eu puxo o modal.
                    Button {
                        // essa variável que fica nula, quando ela recebe esse valor, o modal é puxado
                        editGuild = guild
                    } label: {
                        HStack {
                            Text(guild.name)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
                    .foregroundStyle(Color.primary)
                }
                // Puxa a função de delete.
                .onDelete(perform: deleteCharacter)
            }
            .navigationTitle("Guildas")
            // Botões dos cantos superiores
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        editGuild = nil
                        showAddScreen = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            // Esse modal é puxado com uma variável booleana
            .sheet(isPresented: $showAddScreen) {
                CharacterSheetView()
                    .presentationDragIndicator(.visible)
            }
            // Isso aqui foi magia, o guild in percorre a variável, assim que ela recebe um valor, ele reconhece e o modal aparece.
            .sheet(item: $editGuild) { guild in
                CharacterSheetView(editedGuild: guild)
                    .presentationDragIndicator(.visible)
            }
        }
    }
    
    // Pega o offset que o list já fornece, percorre os dados salvos e exclui o respectivo daquele vetor.
    func deleteCharacter(at offsets: IndexSet) {
        offsets.forEach { index in
            let obj = guilds[index]
            viewContext.delete(obj)
        }
        // Salva o contexto com a função pronta do coordinator
        coordinator.saveContext(viewContext)
    }
}

#Preview {
    // Todo preview para funciona precisa do manager com .preview e contexto para receber o contexto do banco e precisa do .coreDataManager para puxar as funções personalizadas

    CharacterView()
        .environment(\.managedObjectContext, CoreDataManager.preview.container.viewContext)
        .environment(\.coreDataManager, CoreDataManager.preview)
    
}
