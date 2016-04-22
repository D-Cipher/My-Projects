//
//  FirebaseModel.swift
//  Hello World
//
//  Created by Tingbo Chen on 4/21/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation
import Firebase
import CoreData

protocol FirebaseModel {
    func upload(rootRef: Firebase, context: NSManagedObjectContext)
}

