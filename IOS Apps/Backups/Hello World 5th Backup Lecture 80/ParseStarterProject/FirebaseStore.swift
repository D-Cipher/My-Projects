//
//  FirebaseStore.swift
//  Hello World
//
//  Created by Tingbo Chen on 4/26/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation
import Firebase
import CoreData

class FirebaseStore {
    private let context: NSManagedObjectContext
    private let rootRef = Firebase(url: "https://helloworld-0.firebaseio.com")
    
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
    
}

extension FirebaseStore: RemoteStore {
    func startSyncing() {
        /*
        context.performBlock {
            self.observeStatuses()
            self.observeChats()
        }
        */
    }
    
    func store(inserted inserted: [NSManagedObject], updated: [NSManagedObject], deleted: [NSManagedObject]) {
        inserted.forEach(upload)
        /*do {
            try context.save()
        } catch {
            print("store save error")
        }*/
    }
    
    func signUp(phoneNumber phoneNumber: String, facebookID: String, success: () -> (), error: (errorMessage: String) -> ()) {
    rootRef.childByAppendingPath("users").childByAppendingPath(facebookID).updateChildValues(["phoneNumber" : phoneNumber])
        
        FirebaseStore.currentPhoneNumber = phoneNumber
        
    }
    
    
}