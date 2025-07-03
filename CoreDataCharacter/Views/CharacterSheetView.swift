import SwiftUI

struct CharacterSheetView: View {
        
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.coreDataManager) private var coordinator
    
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    var editedCharacter: Character?
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Nome", text: $name)
                .onAppear {
                    if let character = editedCharacter {
                        name = character.name
                    }
                }
                Button("Salvar") {
                    
                    if let character = editedCharacter {
                        character.name = name
                    } else {
                        let character = Character(context: viewContext)
                        character.id = UUID()
                        character.name = name
                    }
                    
                    coordinator.saveContext(viewContext)
                    
                    dismiss()
                }
            }
            .padding(.top, 20)
            .ignoresSafeArea(.all)
            .navigationTitle(editedCharacter != nil ? "Personagem" : "Novo Personagem")
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
    
    let char = Character(context: viewContext)
    char.name = "Test"
    char.id = UUID()
    char.age = 10
    
    return CharacterSheetView(editedCharacter: char).environment(\.managedObjectContext, CoreDataManager.preview.container.viewContext)
}
