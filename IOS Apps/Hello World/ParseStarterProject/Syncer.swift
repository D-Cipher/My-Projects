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
    
    init(mainContext: NSManagedObjectContext, backgroundContext: NSManagedObjectContext) {
        self.mainContext = mainContext
        self.backgroundContext = backgroundContext
        
        super.init()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("mainContextSaved:"), name: NSManagedObjectContextDidSaveNotification, object: mainContext)
            
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("backgroundContextSaved:"), name: NSManagedObjectContextDidSaveNotification, object: backgroundContext)
    }
    
    func mainContextSaved(notification: NSNotification) {
        backgroundContext.performBlock({
            self.backgroundContext.mergeChangesFromContextDidSaveNotification(notification)
        })
    }
    
    func backgroundContextSaved(notification: NSNotification) {
        mainContext.performBlock({
            self.mainContext.mergeChangesFromContextDidSaveNotification(notification)
        })
    }

}


