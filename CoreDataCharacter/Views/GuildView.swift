import SwiftUI
import CoreData

import SwiftUI

struct GuildView: View  {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(entity: Character.entity(), sortDescriptors: []) var characters: FetchedResults<Character>
    
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
            }
            .navigationTitle("Guildas")
        }
    }
}

#Preview {
    GuildView()
}
