//
//  Case.swift
//  
//
//  Created by Tingbo Chen on 1/4/16.
//  Copyright © 2016 Tingbo Chen. All rights reserved.
//

import Foundation
import CoreData

class Case: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var caseTitle: String?
    @NSManaged var group: MyGroups
    @NSManaged var categories: NSSet

    class func createInManagedObjectContext(moc: NSManagedObjectContext, id: NSNumber, caseTitle:String?, group:MyGroups, categories:NSSet) -> Case {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("Case", inManagedObjectContext: moc) as! Case
        newItem.id = id
        newItem.caseTitle = caseTitle
        newItem.group = group
        newItem.categories = categories
        return newItem
        
    }
}
