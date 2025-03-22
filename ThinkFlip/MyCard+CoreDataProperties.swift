//
//  MyCard+CoreDataProperties.swift
//  ThinkFlip
//
//  Created by Pranav on 22/03/25.
//
//

import Foundation
import CoreData


extension MyCard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyCard> {
        return NSFetchRequest<MyCard>(entityName: "MyCard")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var desc: String?
    @NSManaged public var createdAt: Date?

}

extension MyCard : Identifiable {

}
