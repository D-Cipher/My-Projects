//
//  AnswerChoice.swift
//  
//
//  Created by Tingbo Chen on 1/4/16.
//  Copyright © 2016 Tingbo Chen. All rights reserved.
//

import Foundation
import CoreData

class AnswerChoice: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var choiceText: String?
    @NSManaged var correctAnswer: NSNumber
    @NSManaged var category: Category
    
    class func createInManagedObjectContext(moc: NSManagedObjectContext, id: NSNumber, choiceText:String?, correctAnswer: NSNumber, category: Category) -> AnswerChoice {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("AnswerChoice", inManagedObjectContext: moc) as! AnswerChoice
        newItem.id = id
        newItem.choiceText = choiceText
        newItem.correctAnswer = correctAnswer
        newItem.category = category
        return newItem
        
    }

}
