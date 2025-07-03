//
//  Character+CoreDataProperties.swift
//  CoreDataCharacter
//
//  Created by Paulo Henrique Costa Alves on 02/07/25.
//
//

import Foundation
import CoreData


extension Character {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Character> {
        return NSFetchRequest<Character>(entityName: "Character")
    }

    @NSManaged public var age: Int64
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var guild: Guild?
    @NSManaged public var itens: NSSet?
    @NSManaged public var power: Power?

}

// MARK: Generated accessors for itens
extension Character {

    @objc(addItensObject:)
    @NSManaged public func addToItens(_ value: Item)

    @objc(removeItensObject:)
    @NSManaged public func removeFromItens(_ value: Item)

    @objc(addItens:)
    @NSManaged public func addToItens(_ values: NSSet)

    @objc(removeItens:)
    @NSManaged public func removeFromItens(_ values: NSSet)

}

extension Character : Identifiable {

}
