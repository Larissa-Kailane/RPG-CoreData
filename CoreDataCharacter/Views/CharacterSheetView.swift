import SwiftUI

struct CharacterSheetView: View {
        
    // Variáveis de environment
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.coreDataManager) private var coordinator
    
    // Essa e pra fechar o modal
    @Environment(\.dismiss) var dismiss
    
    // Variável do nome novo ou se é um editável
    @State private var name = ""
    var editedGuild: Guild?
    
    var body: some View {
        NavigationStack {
            Spacer()
            Form {
                TextField("Nome", text: $name)
                // Esse onAppear serve para preencher com o nome já salvo em caso de edição.
                .onAppear {
                    if let guild = editedGuild {
                        name = guild.name
                    }
                }
                Button("Salvar") {
                    
                    // O salvamento muda, se tiver um valor na variável de edição, esse valor é sobrescrito, caso não, ele é salvo como um novo.
                    if let guild = editedGuild {
                        guild.name = name
                    } else {
                        let guild = Guild(context: viewContext)
                        guild.id = UUID()
                        guild.name = name
                    }
                    
                    // Salva o contexto
                    coordinator.saveContext(viewContext)
                    
                    // Fecha o modal
                    dismiss()
                }
            }
            // Estilizações
            .padding(.top, 20)
            .ignoresSafeArea(.all)
            .navigationTitle(editedGuild != nil ? "Personagem" : "Novo Personagem")
            .navigationBarTitleDisplayMode(.inline)
            // Botão de cancelar.
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    // Dados mock para funcionar o preview, pois ele não tem o valor de edição se formos ver só essa tela.
    let viewContext = CoreDataManager.preview.container.viewContext
    
    let guild = Guild(context: viewContext)
    guild.name = "Teste"
    guild.id = UUID()
    
    // Todo preview com dado mock aparentemente precisa do return
    return CharacterSheetView(editedGuild: guild)
        .environment(\.managedObjectContext, CoreDataManager.preview.container.viewContext)
        .environment(\.coreDataManager, CoreDataManager.preview)
}
