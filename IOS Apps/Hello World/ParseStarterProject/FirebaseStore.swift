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
    
    private var currentPhoneNumber: String? {
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
}

extension FirebaseStore: RemoteStore {
    func startSyncing() {
        
    }
    
    func store(inserted inserted: [NSManagedObject], updated: [NSManagedObject], deleted: [NSManagedObject]) {
    }
    
    func signUp(phoneNumber phoneNumber: String, facebookID: String, success: () -> (), error: (errorMessage: String) -> ()) {
        
        rootRef.childByAppendingPath("users").childByAppendingPath(facebookID).updateChildValues(["phoneNumber" : phoneNumber])
        
        self.currentPhoneNumber = phoneNumber
        
    }
}