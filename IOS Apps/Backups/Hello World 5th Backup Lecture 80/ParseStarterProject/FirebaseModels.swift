//
//  FirebaseModels.swift
//  Hello World
//
//  Created by Tingbo Chen on 4/26/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation
import Firebase
import CoreData

protocol FirebaseModel {
    func upload(rootRef: Firebase, context: NSManagedObjectContext)
}

extension Contact: FirebaseModel {
    /*
    static func new(forPhoneNumber phoneNumberVal: String, rootRef: Firebase, inContext context: NSManagedObjectContext) -> Contact {
        let contact = NSEntityDescription.insertNewObjectForEntityForName("Contact", inManagedObjectContext: context) as! Contact
        let phoneNumber = NSEntityDescription.insertNewObjectForEntityForName("PhoneNumber", inManagedObjectContext: context) as! PhoneNumber
        
        phoneNumber.contact = contact
        phoneNumber.registered = true
        phoneNumber.value = phoneNumberVal
        contact.getContactID(context, phoneNumber: phoneNumberVal, rootRef: rootRef)
        
        return contact
    }
    
    static func existing(withPhoneNumber phoneNumber: String, rootRef: Firebase, inContext context: NSManagedObjectContext) -> Contact? {
        let request = NSFetchRequest(entityName: "PhoneNumber")
        
        request.predicate = NSPredicate(format: "value=%@", phoneNumber)
        
        do {
            if let results = try context.executeFetchRequest(request) as? [PhoneNumber]
                where results.count > 0 {
                let contact = results.first!.contact!
                if contact.storageID == nil {
                    contact.getContactID(context, phoneNumber: phoneNumber, rootRef: rootRef)
                }
                return contact
            }
        } catch {print("error fetching")}
        
        return nil
    }
    
    func getContactID(context: NSManagedObjectContext, phoneNumber: String, rootRef: Firebase) {
        rootRef.childByAppendingPath("users").queryOrderedByChild("phoneNumber").queryEqualToValue(phoneNumber).observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            
            guard let user = snapshot.value as? NSDictionary else {return}
            
            let uid = user.allKeys.first as? String
            
            context.performBlock {
                self.storageID = uid
                do {
                    try context.save()
                } catch {
                    print("error savying")
                }
            }
        })
    }*/
    
    func upload(rootRef: Firebase, context: NSManagedObjectContext) {
        guard let phoneNumbers = phoneNumbers?.allObjects as? [PhoneNumber] else {return}
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
            for number in phoneNumbers {
                rootRef.childByAppendingPath("users").queryOrderedByChild("phoneNumber").queryEqualToValue(number.value).observeSingleEventOfType(.Value, withBlock: { snapshot in
                    
                    //print(number.value)
                    
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
                        
                        //self.observerStatus(rootRef, context: context)
                    })
                })
            }
        })
    }
    /*
    func observerStatus(rootRef:Firebase, context: NSManagedObjectContext) {
        rootRef.childByAppendingPath("users/"+storageID!+"/status").observeEventType(.Value, withBlock: { snapshot in
            guard let status = snapshot.value as? String else {return}
            
            context.performBlock {
                self.status = status
                do {
                    try context.save()
                } catch {
                    print("error saving")
                }
            }
        })
    }*/
}