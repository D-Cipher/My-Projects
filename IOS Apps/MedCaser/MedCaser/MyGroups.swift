//
//  MyGroups.swift
//  
//
//  Created by Tingbo Chen on 1/4/16.
//  Copyright © 2016 Tingbo Chen. All rights reserved.
//

import Foundation
import CoreData

class MyGroups: NSManagedObject {

    @NSManaged var groupName: String
    @NSManaged var id: NSNumber
    @NSManaged var cases: NSSet

    
    class func createInManagedObjectContext(moc: NSManagedObjectContext, id: NSNumber, groupName: String, cases: NSSet) -> MyGroups {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("MyGroups", inManagedObjectContext: moc) as! MyGroups
        newItem.id = id
        newItem.groupName = groupName
        newItem.cases = cases
        return newItem
        
    }
}
