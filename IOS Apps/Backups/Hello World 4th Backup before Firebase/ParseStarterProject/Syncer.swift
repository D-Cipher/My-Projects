//
//  Syncer.swift
//  Hello World
//
//  Created by Tingbo Chen on 4/15/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import CoreData

/*/====Extension====//
 Name: Syncer
 File: Syncer.swift
 
 ===Description===
 Extension that helps to keep the main thread
 and the background thread synced.
 
 * Copyright 2016 d-cy.
 * Credit: Cy at http://www.d-cy.net
 * https://github.com/D-Cipher
 * License: GPL v3
 */

class Syncer: NSObject {
    
    private var mainContext: NSManagedObjectContext
    private var backgroundContext: NSManagedObjectContext
    
    var remoteStore: RemoteStore?
    
    init(mainContext: NSManagedObjectContext, backgroundContext: NSManagedObjectContext) {
        self.mainContext = mainContext
        self.backgroundContext = backgroundContext
        
        super.init()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("mainContextSaved:"), name: NSManagedObjectContextDidSaveNotification, object: mainContext)
            
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("backgroundContextSaved:"), name: NSManagedObjectContextDidSaveNotification, object: backgroundContext)
    }
    
    func mainContextSaved(notification: NSNotification) {
        backgroundContext.performBlock({
            
            let inserted = self.objectsForKey(NSInsertedObjectsKey, dictionary: notification.userInfo!, context: self.backgroundContext)
            let updated = self.objectsForKey(NSUpdatedObjectsKey, dictionary: notification.userInfo!, context: self.backgroundContext)
            let deleted = self.objectsForKey(NSDeletedObjectsKey, dictionary: notification.userInfo!, context: self.backgroundContext)
            
            
            self.backgroundContext.mergeChangesFromContextDidSaveNotification(notification)
            
            
            self.remoteStore?.store(inserted: inserted, updated: updated, deleted: deleted)
        })
    }
    
    func backgroundContextSaved(notification: NSNotification) {
        mainContext.performBlock({
            self.objectsForKey(NSUpdatedObjectsKey, dictionary: notification.userInfo!, context: self.mainContext).forEach{$0.willAccessValueForKey(nil)}
            self.mainContext.mergeChangesFromContextDidSaveNotification(notification)
            
            
            self.mainContext.mergeChangesFromContextDidSaveNotification(notification)
        })
    }
    
    private func objectsForKey(key: String, dictionary: NSDictionary, context: NSManagedObjectContext)-> [NSManagedObject] {
        guard let set = (dictionary[key] as? NSSet) else {return []}
        guard let objects = set.allObjects as? [NSManagedObject] else {return []}
        return objects.map{context.objectWithID($0.objectID)}
    }

}


