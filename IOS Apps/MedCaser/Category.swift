//
//  Category.swift
//  MedCaser
//
//  Created by HingKiu Chan on 7/10/15.
//  Copyright (c) 2015 University of Virginia. All rights reserved.
//

import Foundation
import CoreData

class Category: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var order: NSNumber
    @NSManaged var text: String
    @NSManaged var title: String
    @NSManaged var type: String
    @NSManaged var explanation: String
    @NSManaged var answerChoices: NSSet
    @NSManaged var theCase: Case

}
