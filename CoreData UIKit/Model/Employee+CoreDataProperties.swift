//
//  Employee+CoreDataProperties.swift
//  CoreData UIKit
//
//  Created by Local Administrator on 23/06/22.
//
//

import Foundation
import CoreData


extension Employee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee")
    }

    @NSManaged public var name: String?
    @NSManaged public var isMarried: Bool

}

extension Employee : Identifiable {

}
