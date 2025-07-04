//
//  PersonagensDetailView.swift
//  RPG-CoreData
//
//  Created by Paulo Henrique Costa Alves on 03/07/25.
//

import SwiftUI

struct PersonagensDetailView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss

    var character: Character? // nil = criando novo

    @State private var name = ""
    @State private var title = ""
    @State private var age = 0
    @State private var selectedPower: Power?
    @State private var selectedItems: Set<Item> = []

    @FetchRequest(entity: Power.entity(), sortDescriptors: [])
    var powers: FetchedResults<Power>

    @FetchRequest(entity: Item.entity(), sortDescriptors: [])
    var items: FetchedResults<Item>

    var body: some View {
        NavigationStack {
            Form {
                Section("Informações do personagem") {
                    TextField("Nome", text: $name)
                    TextField("Título", text: $title)
                    TextField("Idade", text: Binding(
                        get: { String(age) },
                        set: { newValue in
                            if let intValue = Int(newValue) {
                                age = intValue
                            } else if newValue.isEmpty {
                                age = 0
                            }
                        }
                    ))
                    .keyboardType(.numberPad)

                }

                Section("Poder") {
                    let powersNotSelected = Array(powers).filter { $0.character == nil || $0 == selectedPower }
                    ForEach(powersNotSelected, id: \.self) { power in
                        HStack {
                            switch power.name{
                            case "Supervelocidade":
                                Image(systemName: "bolt.circle.fill")
                                    .foregroundStyle(.yellow)
                            case "Visão de raio lazer":
                                Image(systemName: "sunglasses")
                                    .foregroundStyle(.blue)
                            case "Controle de tempestades":
                                Image(systemName: "cloud.bolt")
                                    .foregroundStyle(.orange)
                            case "Domínio da Terra":
                                Image(systemName: "mountain.2.fill")
                                    .foregroundStyle(.green)
                            case "Em chamas":
                                Image(systemName: "flame")
                                    .foregroundStyle(.red)
                            case "Elasticidade":
                                Image(systemName: "heat.waves")
                                    .foregroundStyle(.pink)
                            default:
                                Image(systemName: "plus")
                            }
                            Text(power.name ?? "Sem nome")
                            Spacer()
                            if selectedPower == power {
                                Image(systemName: "checkmark")
                            }
                        }
                        .contentShape(Rectangle()) // Faz toda a linha ficar "clicável"
                        .onTapGesture {
                            selectedPower = power
                        }
                    }
                }

                Section("Itens (escolha 2)") {
                    ForEach(items, id: \.self) { item in
                        MultipleSelectionRow(
                            title: item.name ?? "Sem nome",
                            isSelected: selectedItems.contains(item)
                        ) {
                            if selectedItems.contains(item) {
                                selectedItems.remove(item)
                            } else if selectedItems.count < 2 {
                                selectedItems.insert(item)
                            }
                        }
                    }
                }
            }
            .navigationTitle(character == nil ? "Novo Personagem" : "Editar Personagem")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salvar") {
                        saveCharacter()
                    }
                    .disabled(
                        name.isEmpty || title.isEmpty || selectedPower == nil || selectedItems.count != 2
                    )
                }
            }

            .onAppear { loadDataIfEditing() }
        }
    }

    private func loadDataIfEditing() {
        guard let character else { return }
        name = character.name ?? ""
        title = character.title ?? ""
        age = Int(character.age)
        selectedPower = character.power
        selectedItems = (character.items as? Set<Item>) ?? []
    }

    private func saveCharacter() {
        if selectedItems.count > 2 {
               print("Erro: não pode ter mais de 2 itens.")
               return
        }

        let char = character ?? Character(context: viewContext)
        char.id = char.id ?? UUID()
        char.name = name
        char.title = title
        char.age = Int16(age)
        char.power = selectedPower
        char.items = NSSet(set: selectedItems)

        PersistenceController.shared.save()
        dismiss()
    }

}


