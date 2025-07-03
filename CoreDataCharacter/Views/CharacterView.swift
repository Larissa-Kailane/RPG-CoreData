import SwiftUI
import CoreData

import SwiftUI

struct CharacterView: View  {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.coreDataManager) private var coordinator
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Character.id, ascending: true)], animation: .default)
    private var characters: FetchedResults<Character>
    
    @State private var showAddScreen = false
    @State private var editCharacter: Character?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(characters, id: \.id) { character in
                    Button {
                        editCharacter = character
                    } label: {
                        HStack {
                            Text(character.name)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
                    .foregroundStyle(Color.primary)
                }
                .onDelete(perform: deleteCharacter)
            }
            .navigationTitle("<Nome da Guilda>")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        editCharacter = nil
                        showAddScreen = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showAddScreen) {
                CharacterSheetView()
            }
            .sheet(item: $editCharacter) { character in
                CharacterSheetView(editedCharacter: character)
            }
        }
    }
    
    func deleteCharacter(at offsets: IndexSet) {
        offsets.forEach { index in
            let obj = characters[index]
            viewContext.delete(obj)
        }
        coordinator.saveContext(viewContext)
    }
}

#Preview {
    CharacterView()/*.environment(\.managedObjectContext, CoreDataManager.preview.container.viewContext)*/
}
