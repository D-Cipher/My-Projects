//
//  Contact+CoreDataProperties.swift
//  Hello World
//
//  Created by Tingbo Chen on 4/23/16.
//  Copyright © 2016 Parse. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Contact {

    @NSManaged var contactID: String?
    @NSManaged var favorite: Bool
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var status: String?
    @NSManaged var nonAlphaName: String?
    @NSManaged var chats: NSSet?
    @NSManaged var messages: NSSet?
    @NSManaged var phoneNumbers: NSSet?

}
