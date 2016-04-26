//
//  ContextViewController.swift
//  Hello World
//
//  Created by Tingbo Chen on 4/13/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation
import CoreData

protocol ContextViewController {
    var context: NSManagedObjectContext? {get set}
}