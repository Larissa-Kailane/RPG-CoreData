//
//  Persistence.swift
//  RPG-CoreData
//
//  Created by Larissa Kailane on 02/07/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "RPG_CoreData")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        // Código que roda ao inicializar o banco
        let context = container.viewContext
        let request: NSFetchRequest<Guild> = Guild.fetchRequest()
        let count = (try? context.count(for: request)) ?? 0
        if count == 0 {
            // Só cria se não existir nenhuma guilda
            let guild1 = Guild(context: context)
            guild1.id = UUID()
            guild1.name = "Ordem dos bits"

            let guild2 = Guild(context: context)
            guild2.id = UUID()
            guild2.name = "Clã dos dados"

            try? context.save()
        }

        container.viewContext.automaticallyMergesChangesFromParent = true

        // Popula dados iniciais só se for banco real
        if !inMemory {
            seedInitialDataIfNeeded(context: container.viewContext)
        }
    }//fim do init
    
    //salvando o contexto
    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("Contexto salvo com sucesso")
            } catch {
                let nserror = error as NSError
                fatalError("Erro ao salvar contexto: \(nserror), \(nserror.userInfo)")
            }
        }
    }


    /// Função que cria poderes e itens caso ainda não existam
    private func seedInitialDataIfNeeded(context: NSManagedObjectContext) {
        let powerRequest: NSFetchRequest<Power> = Power.fetchRequest()
        let itemRequest: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            let powerCount = try context.count(for: powerRequest)
            let itemCount = try context.count(for: itemRequest)

            if powerCount == 0 {
                let powerNames = [
                    "Supervelocidade",
                    "Visão de raio lazer",
                    "Controle de tempestades",
                    "Domínio da Terra",
                    "Em chamas",
                    "Elasticidade"
                ]
                for name in powerNames {
                    let power = Power(context: context)
                    power.id = UUID()
                    power.name = name
                }
            }

            if itemCount == 0 {
                let itemNames = [
                    "Arma laser",
                    "Escudo de energia",
                    "Pendrive",
                    "Espada de energia",
                    "Granadas explosivas",
                    "Chicotes USB"
                ]
                for name in itemNames {
                    let item = Item(context: context)
                    item.id = UUID()
                    item.name = name
                }
            }

            if powerCount == 0 || itemCount == 0 {
                try context.save()
                print("Poderes e itens criados no banco de dados.")
            }
        } catch {
            print("Erro ao criar dados iniciais: \(error.localizedDescription)")
        }
    }
}
