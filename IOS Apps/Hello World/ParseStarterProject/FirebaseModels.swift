//
//  FirebaseModels.swift
//  Hello World
//
//  Created by Tingbo Chen on 4/21/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation
import Firebase
import CoreData

protocol FirebaseModel {
    func upload(rootRef: Firebase, context: NSManagedObjectContext)
}

extension Contact: FirebaseModel {
    func upload(rootRef: Firebase, context: NSManagedObjectContext) {
        guard let phoneNumbers = phoneNumbers?.allObjects as? [PhoneNumber] else {return}
        
        for number in phoneNumbers {
            rootRef.childByAppendingPath("users").queryOrderedByChild("phoneNumber").queryEqualToValue(number.value).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                
                guard let user = snapshot.value as? NSDictionary else {return}
                
                let uid = user.allKeys.first as? String
                
                context.performBlock({
                    self.storageID = uid
                    number.registered = true
                    
                    do {
                        try context.save()
                    } catch {
                        print("error saving")
                    }
                })
            })
        }
    }
}