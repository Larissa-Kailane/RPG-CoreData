//
//  Power+CoreDataProperties.swift
//  CoreDataCharacter
//
//  Created by Paulo Henrique Costa Alves on 02/07/25.
//
//

import Foundation
import CoreData


extension Power {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Power> {
        return NSFetchRequest<Power>(entityName: "Power")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var character: Character?

}

extension Power : Identifiable {

}
