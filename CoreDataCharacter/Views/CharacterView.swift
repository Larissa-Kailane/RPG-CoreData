import SwiftUI
import CoreData

import SwiftUI

struct CharacterView: View  {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.coreDataManager) private var coordinator
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Guild.id, ascending: true)], animation: .default)
    private var guilds: FetchedResults<Guild>
    
    @State private var showAddScreen = false
    @State private var editGuild: Guild?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(guilds, id: \.id) { guild in
                    Button {
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
                .onDelete(perform: deleteCharacter)
            }
            .navigationTitle("Guildas")
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
            .sheet(isPresented: $showAddScreen) {
                CharacterSheetView()
                    .presentationDragIndicator(.visible)
            }
            .sheet(item: $editGuild) { guild in
                CharacterSheetView(editedGuild: guild)
                    .presentationDragIndicator(.visible)
            }
        }
    }
    
    func deleteCharacter(at offsets: IndexSet) {
        offsets.forEach { index in
            let obj = guilds[index]
            viewContext.delete(obj)
        }
        coordinator.saveContext(viewContext)
    }
}

#Preview {
    CharacterView()
        .environment(\.managedObjectContext, CoreDataManager.preview.container.viewContext)
        .environment(\.coreDataManager, CoreDataManager.preview)
    
}
