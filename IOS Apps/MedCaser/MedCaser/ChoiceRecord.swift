//
//  ChoiceRecord.swift
//  
//
//  Created by Tingbo Chen on 1/4/16.
//  Copyright © 2016 Tingbo Chen. All rights reserved.
//

import Foundation
import CoreData

class ChoiceRecord: NSManagedObject {

    @NSManaged var categoryId: NSNumber
    @NSManaged var choiceId: NSNumber
    
    class func createInManagedObjectContext(moc: NSManagedObjectContext, categoryId: NSNumber, choiceId: NSNumber) -> ChoiceRecord {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("ChoiceRecord", inManagedObjectContext: moc) as! ChoiceRecord
        newItem.categoryId = categoryId
        newItem.choiceId = choiceId
        return newItem
        
    }

}
