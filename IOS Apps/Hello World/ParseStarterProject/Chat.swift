//
//  Chat.swift
//  Hello World
//
//  Created by Tingbo Chen on 4/10/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation
import CoreData


class Chat: NSManagedObject {
    
    //Check if Group Chat
    var isGroupChat: Bool {
        return participants?.count > 1
    }

    //Adding a computed property to grab the last message in instance
    var lastMessage: Message? {
        let request = NSFetchRequest(entityName: "Message")
        request.predicate = NSPredicate(format: "chat = %@", self)
        request.sortDescriptors = [NSSortDescriptor(key:"timestamp", ascending: false)]
        request.fetchLimit = 1
        
        do {
            guard let results = try self.managedObjectContext?.executeFetchRequest(request) as? [Message] else {return nil}
            return results.first
        } catch {
            print("Error in fetching request")
        }
        return nil
    }
    
    func add(participant contact: Contact) {
        mutableSetValueForKey("participants").addObject(contact)
    }
    
    //===Check for Chat Instances that matches Contact parameter===
    static func existing(directWith contact: Contact, inContext context: NSManagedObjectContext) -> Chat? {
        
        let request = NSFetchRequest(entityName: "Chat")
        request.predicate = NSPredicate(format: "ANY participants = %@ AND participants.@count = 1", contact)
        
        do {
            guard let results = try context.executeFetchRequest(request) as? [Chat]
                else {return nil}
            
            return results.first
        } catch {
            print("Error Fetching")
        }
        return nil
    }
    
    static func new(directWith contact: Contact, inContext context: NSManagedObjectContext) -> Chat {
        let chat = NSEntityDescription.insertNewObjectForEntityForName("Chat", inManagedObjectContext: context) as! Chat
        chat.add(participant: contact)
        return chat
    }
}
