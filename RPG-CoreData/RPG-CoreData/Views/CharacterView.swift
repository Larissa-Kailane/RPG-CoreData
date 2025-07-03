import SwiftUI
import CoreData

struct CharacterView: View {
    @Environment(\.managedObjectContext) var viewContext
    
    // Nome da guilda recebida ao clicar
    let guildName: String
    
    // FetchRequest que filtra só os personagens dessa guilda
    @FetchRequest var characters: FetchedResults<Character>
    
    @State private var isDetailActive = false
    @State private var selectedCharacter: Character?
    
    // Inicializador que configura o filtro
    init(guildName: String) {
        self.guildName = guildName
        _characters = FetchRequest(
            entity: Character.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Character.name, ascending: true)
            ],
            predicate: NSPredicate(format: "guildName == %@", guildName)
        )
    }//fim do init
    
    var body: some View {
        List {
            if characters.isEmpty {
                Text("Nenhum personagem nesta guilda.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(characters, id: \.id) { character in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(character.title ?? "Sem título")
                            .font(.headline)
                        Text(character.name ?? "Sem nome")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }//fim do forEach
            }//fim do else
        }//fim do list
        .navigationTitle(guildName)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    selectedCharacter = nil // cria novo personagem
                    isDetailActive = true
                } label: {
                    Image(systemName: "plus")
                }//fim do label
                
            }//fim do toolbar item - add
        }//fim do toolbar
        
        
    }//fim do body
}//fim da struct
#Preview {
    CharacterView(guildName: "Guild Name")
}
