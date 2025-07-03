import SwiftUI

struct CharacterSheetView: View {
        
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.coreDataManager) private var coordinator
    
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    var editedGuild: Guild?
    
    var body: some View {
        NavigationStack {
            Spacer()
            Form {
                TextField("Nome", text: $name)
                .onAppear {
                    if let guild = editedGuild {
                        name = guild.name
                    }
                }
                Button("Salvar") {
                    
                    if let guild = editedGuild {
                        guild.name = name
                    } else {
                        let guild = Guild(context: viewContext)
                        guild.id = UUID()
                        guild.name = name
                    }
                    
                    coordinator.saveContext(viewContext)
                    
                    dismiss()
                }
            }
            .padding(.top, 20)
            .ignoresSafeArea(.all)
            .navigationTitle(editedGuild != nil ? "Personagem" : "Novo Personagem")
            .navigationBarTitleDisplayMode(.inline)
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
    let viewContext = CoreDataManager.preview.container.viewContext
    
    let guild = Guild(context: viewContext)
    guild.name = "Teste"
    guild.id = UUID()
    
    return CharacterSheetView(editedGuild: guild)
        .environment(\.managedObjectContext, CoreDataManager.preview.container.viewContext)
        .environment(\.coreDataManager, CoreDataManager.preview)
}
