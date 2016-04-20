//
//  RemoteStore.swift
//  Hello World
//
//  Created by Tingbo Chen on 4/18/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation
import CoreData

/*/====Extension====//
 Name: RemoteStore
 File: RemoteStore.swift
 
 ===Description===
 Extension that helps to maintain user
 signup authentication.
 
 * Copyright 2016 d-cy.
 * Credit: Cy at http://www.d-cy.net
 * https://github.com/D-Cipher
 * License: GPL v3
 */

protocol RemoteStore {
    func signUp(facebookID facebookID: String, success: ()->(), error:(errorMessage: String)->())
    
    func startSyncing()
    
    func store(inserted inserted: [NSManagedObject], updated: [NSManagedObject], deleted: [NSManagedObject])
}