//
//  User+CoreDataProperties.swift
//  
//
//  Created by IwasakIYuta on 2021/08/13.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var createAt: Date?

}
