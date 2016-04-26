//
//  RemoteStore.swift
//  Hello World
//
//  Created by Tingbo Chen on 4/18/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation
import CoreData

protocol RemoteStore {
    func signUp(phoneNumber phoneNumber: String, facebookID: String, success: ()->(), error:(errorMessage: String)->())
    
    func startSyncing()
    
    func store(inserted inserted: [NSManagedObject], updated: [NSManagedObject], deleted: [NSManagedObject])
}