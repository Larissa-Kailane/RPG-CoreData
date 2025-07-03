//
//  Guild+CoreDataProperties.swift
//  CoreDataCharacter
//
//  Created by Paulo Henrique Costa Alves on 02/07/25.
//
//

import Foundation
import CoreData


extension Guild {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Guild> {
        return NSFetchRequest<Guild>(entityName: "Guild")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var caracters: NSSet?

}

// MARK: Generated accessors for caracters
extension Guild {

    @objc(addCaractersObject:)
    @NSManaged public func addToCaracters(_ value: Character)

    @objc(removeCaractersObject:)
    @NSManaged public func removeFromCaracters(_ value: Character)

    @objc(addCaracters:)
    @NSManaged public func addToCaracters(_ values: NSSet)

    @objc(removeCaracters:)
    @NSManaged public func removeFromCaracters(_ values: NSSet)

}

extension Guild : Identifiable {

}
