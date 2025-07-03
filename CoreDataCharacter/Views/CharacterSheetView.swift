// O código deste arquivo foi gerado inteiramente pelo gemini.
// Não considerem este código como finalizado.


import SwiftUI
import CoreData

struct CharacterSheetView: View {
    
    // 1. Acesso ao ambiente do Core Data para podermos salvar.
    @Environment(\.managedObjectContext) var managedObjectContext
    
    // 2. Acesso ao comando para fechar a tela (a sheet).
    @Environment(\.dismiss) var dismiss
    
    // 3. Variável de estado para guardar o nome que o usuário digita.
    @State private var name = ""
    
    // 4. Propriedade opcional para edição.
    // Se esta tela for usada para editar, este objeto existirá.
    // Se for para criar um novo, ele será 'nil'.
    var editedCharacter: Character?
    
    // 5. A Guilda à qual o personagem pertence.
    // Esta é a informação CRUCIAL que recebemos da CharacterView.
    // Não é opcional, esta tela PRECISA saber a guilda.
    let guild: Guild
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Nome do Personagem", text: $name)
                // O modificador .onAppear é útil para preencher o campo de texto
                // caso estejamos no modo de edição.
                .onAppear {
                    if let character = editedCharacter {
                        name = character.name ?? ""
                    }
                }
            }
            .navigationTitle(editedCharacter != nil ? "Editar Personagem" : "Novo Personagem")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Botão de Cancelar na esquerda
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss() // Apenas fecha a tela.
                    }
                }
                
                // Botão de Salvar na direita
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Salvar") {
                        saveCharacter() // Chama nossa função de salvar.
                    }
                    // Desabilita o botão se o nome estiver vazio, para evitar
                    // criar personagens sem nome.
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    // Função para centralizar a lógica de salvar.
    private func saveCharacter() {
        if let character = editedCharacter {
            // MODO DE EDIÇÃO: Apenas atualiza o nome do personagem existente.
            character.name = name
        } else {
            // MODO DE CRIAÇÃO:
            // 1. Cria uma nova instância de 'Character' no contexto do Core Data.
            let newCharacter = Character(context: managedObjectContext)
            
            // 2. Atribui as propriedades.
            newCharacter.id = UUID() // É uma boa prática dar um ID único.
            newCharacter.name = name
            
            // 3. ✨ A LIGAÇÃO MÁGICA ✨
            // Esta é a linha mais importante: associamos o novo personagem
            // à guilda que esta tela recebeu.
            newCharacter.guild = guild
        }
        
        // Tenta salvar as mudanças (seja edição ou criação) no disco.
        do {
            try managedObjectContext.save()
            // Após salvar, fecha a tela para voltar à lista de personagens.
            dismiss()
        } catch {
            // Se houver um erro ao salvar, é bom ter um feedback.
            print("Erro ao salvar o personagem: \(error.localizedDescription)")
        }
    }
}

// Enviando o preview para o purgatório, conforme solicitado.
// #Preview {
//     // Para o preview funcionar, precisaríamos criar uma Guilda "falsa"
//     // e injetar um contexto de Core Data aqui, como discutimos antes.
// }
