//
//  Category.swift
//  
//
//  Created by Tingbo Chen on 1/4/16.
//  Copyright © 2016 Tingbo Chen. All rights reserved.
//

import Foundation
import CoreData

class Category: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var type: String
    @NSManaged var title: String?
    @NSManaged var text: String?
    @NSManaged var order: NSNumber
    @NSManaged var theCase: Case
    @NSManaged var answerChoices: NSSet
    @NSManaged var explanation: String?

    
    class func createInManagedObjectContext(moc: NSManagedObjectContext, id: NSNumber, type:String, title:String?, text:String?, explanation:String?, order:NSNumber, theCase:Case, answerChoices:NSSet) -> Category {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("Category", inManagedObjectContext: moc) as! Category
        newItem.id = id
        newItem.type = type
        newItem.title = title
        newItem.text = text
        newItem.explanation = explanation
        newItem.order = order
        newItem.theCase = theCase
        newItem.answerChoices = answerChoices
        return newItem
        
    }

}
