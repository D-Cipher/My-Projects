//
//  ChatCreationDelegate.swift
//  Hello World
//
//  Created by Tingbo Chen on 4/11/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation
import CoreData

protocol ChatCreationDelegate {
    func created(chat chat: Chat, inContext context: NSManagedObjectContext)
}