import SwiftUI
import CoreData

struct CharacterView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    //Essa view precisa receber o objeto Guild, se não dá tudo errado.
    let guild: Guild
    
    //A variável State que controla a modal CharacterSheetView
    @State private var mostrarModal = false
    
    var body: some View {
        // Por causa do relacionamento dentro do arquivo CoreDataCharacter, aparentemente a maneira com que trazemos os dados para cá muda.
        let charactersArray = guild.characters?.allObjects as? [Character] ?? []
        
        //Ordenando o array
        let sortedCharacters = charactersArray.sorted {
            $0.name ?? "" < $1.name ?? ""
        }
        
        List {
            // O ForEach abaixo usa a lista ordenada acima, dos personagens que são só da guilda onde estamos
            ForEach(sortedCharacters) { character in
                Text(character.name ?? "Personagem sem nome")
            }
            .onDelete(perform: deleteCharacter)
        }
        .navigationTitle(guild.name ?? "Personagens")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    mostrarModal = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $mostrarModal) {
            // É muito importante lembrar de passar de novo as coisas do CoreData para frente
            CharacterSheetView(guild: guild)
        }
    }
    private func deleteCharacter(at offsets: IndexSet) {
            // Precisamos ter a mesma lista ordenada que usamos no ForEach
        let charactersArray = guild.characters?.allObjects as? [Character] ?? []
            let sortedCharacters = charactersArray.sorted { $0.name ?? "" < $1.name ?? "" }

            for index in offsets {
                let characterToDelete = sortedCharacters[index]
                managedObjectContext.delete(characterToDelete)
            }

            try? managedObjectContext.save()
        }
}
