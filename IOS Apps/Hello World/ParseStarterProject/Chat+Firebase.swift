//
//  Chat+Firebase.swift
//  Hello World
//
//  Created by Tingbo Chen on 4/22/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation
import Firebase
import CoreData

extension Chat: FirebaseModel {
    
    func observeMessages(rootRef: Firebase, context: NSManagedObjectContext) {
        guard let storageID = storageID else {return}
        let lastFetch = lastMessage?.timestamp?.timeIntervalSince1970 ?? 0
        
        rootRef.childByAppendingPath("chats/"+storageID+"/messages").queryOrderedByKey().queryStartingAtValue(String(lastFetch * 1000)).observeEventType(.ChildAdded, withBlock: {
            snapshot in
            context.performBlock{
                guard let phoneNumber = snapshot.value["sender"] as? String where phoneNumber != FirebaseStore.currentPhoneNumber else {return}
                guard let text = snapshot.value["message"] as? String else {return}
                guard let timeInterval = Double(snapshot.key) else {return}
                
                let date = NSDate(timeIntervalSince1970: timeInterval/1000)
                
                guard let message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: context) as? Message else {return}
                
                message.text = text
                message.timestamp = date
                message.sender = Contact.existing(withPhoneNumber: phoneNumber, rootRef: rootRef, inContext: context) ?? Contact.new(forPhoneNumber: phoneNumber, rootRef: rootRef, inContext: context)
                
                message.chat = self
                
                self.lastMessageTime = message.timestamp
                
                do {
                    try context.save()
                } catch {}
            }
        })
    }
    
    static func new(forStorageID storageID: String, rootRef: Firebase, inContext context: NSManagedObjectContext) -> Chat {
        let chat = NSEntityDescription.insertNewObjectForEntityForName("Chat", inManagedObjectContext: context) as! Chat
        chat.storageID = storageID
        
        rootRef.childByAppendingPath("chats/"+storageID+"/meta").observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            guard let data = snapshot.value as? NSDictionary else {return}
            guard let participantsDict = data["participants"] as? NSMutableDictionary else {return}
            
            if FirebaseStore.currentPhoneNumber != nil {
                participantsDict.removeObjectForKey(FirebaseStore.currentPhoneNumber!)
            }
            
            let participants = participantsDict.allKeys.map {
                (phoneNumber: AnyObject) -> Contact in
                let phoneNumber = phoneNumber as! String
                return Contact.existing(withPhoneNumber: phoneNumber, rootRef: rootRef, inContext: context) ?? Contact.new(forPhoneNumber: phoneNumber, rootRef: rootRef, inContext: context)
            }
            let name = data["name"] as? String
            context.performBlock{
                chat.participants = NSSet(array: participants)
                chat.name = name
                do {
                    try context.save()
                } catch {}
                
                chat.observeMessages(rootRef, context: context)
            }
        })
        return chat
    }
    
    static func existing(storageID storageID: String, inContext context: NSManagedObjectContext) -> Chat? {
        let request = NSFetchRequest(entityName: "Chat")
        request.predicate = NSPredicate(format: "storageID=%@", storageID)
        
        do {
            if let results = try context.executeFetchRequest(request) as? [Chat] where results.count > 0 {
                if let chat = results.first {
                    return chat
                }
            }
        } catch {print("Error Fetching")}
        return nil
    }
    
    func upload(rootRef: Firebase, context: NSManagedObjectContext) {
        guard storageID == nil else {return}
        let ref = rootRef.childByAppendingPath("chats").childByAutoId()
        
        storageID = ref.key
        
        var data: [String: AnyObject] = ["id": ref.key,]
        
        guard let participants = participants?.allObjects as? [Contact] else {return}
        
        var numbers = [FirebaseStore.currentPhoneNumber!: true]
        
        let facebookID = rootRef.authData.uid.stringByReplacingOccurrencesOfString("facebook:", withString: "")
        
        var userIDs = [facebookID]
        
        for participant in participants {
            guard let phoneNumbers = participant.phoneNumbers?.allObjects as? [PhoneNumber] else {continue}
            guard let number = phoneNumbers.filter({$0.registered}).first else {continue}
            numbers[number.value!] = true
            userIDs.append(participant.storageID!)
        }
        data["participants"] = numbers
        if let name = name {
            data["name"] = name
        }
        ref.setValue(["meta": data])
        
        for id in userIDs {
            rootRef.childByAppendingPath("users/"+id+"/chats/"+ref.key).setValue(true)
        }
    }
}
