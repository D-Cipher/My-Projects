//
//  FirebaseStore.swift
//  Hello World
//
//  Created by Tingbo Chen on 4/21/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation
import Firebase
import CoreData

class FirebaseStore {
    
    private let context: NSManagedObjectContext
    
    private let rootRef = Firebase(url: "https://dcy-helloworld.firebaseio.com")
    
    private(set) static var currentPhoneNumber: String? {
        set(phoneNumber) {
            NSUserDefaults.standardUserDefaults().setObject(phoneNumber, forKey: "phoneNumber")
        }
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey("phoneNumber") as? String
        }
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    /*
    func hasAuth() -> Bool {
        return rootRef.authData != nil
    }
    */
    
    private func upload(model: NSManagedObject) {
        guard let model = model as? FirebaseModel else {return}
        model.upload(rootRef, context: context)
        
    }
    
    private func listenForNewMessages(chat: Chat) {
        chat.observeMessages(rootRef, context: context)
    }
    
    private func fetchAppContacts() -> [Contact] {
        do {
            let request = NSFetchRequest(entityName: "Contact")
            request.predicate = NSPredicate(format: "storageID != nil")
            
            if let results = try self.context.executeFetchRequest(request) as? [Contact] {
                return results
            }
        } catch {
            print("error fetching contacts")
        }
        return []
    }
    
    private func observeUserStatus(contact: Contact) {
        contact.observerStatus(rootRef, context: context)
    }
    
    private func observeStatuses() {
        let contacts = fetchAppContacts()
        contacts.forEach(observeUserStatus)
    }
    
    private func observeChats() {
        
        let facebookID = self.rootRef.authData.uid.stringByReplacingOccurrencesOfString("facebook:", withString: "")
        
        self.rootRef.childByAppendingPath("users/"+facebookID+"/chats").observeEventType(.ChildAdded, withBlock: {
            snapshot in
            let uid = snapshot.key
            let chat = Chat.existing(storageID: uid, inContext: self.context) ?? Chat.new(forStorageID: uid, rootRef: self.rootRef, inContext: self.context)
            if chat.inserted {
                do {
                    try self.context.save()
                } catch {}
            }
            self.listenForNewMessages(chat)
        })
    }
}

extension FirebaseStore: RemoteStore {
    func startSyncing() {
        context.performBlock {
            self.observeStatuses()
            self.observeChats()
        }
    }
    
    func store(inserted inserted: [NSManagedObject], updated: [NSManagedObject], deleted: [NSManagedObject]) {
        inserted.forEach(upload)
        do {
            try context.save()
        } catch {
            print("store save error")
        }
    }
    
    func signUp(phoneNumber phoneNumber: String, facebookID: String, success: () -> (), error: (errorMessage: String) -> ()) {
        
        rootRef.childByAppendingPath("users").childByAppendingPath(facebookID).updateChildValues(["phoneNumber" : phoneNumber])
        
        FirebaseStore.currentPhoneNumber = phoneNumber
        
    }
    
    
}