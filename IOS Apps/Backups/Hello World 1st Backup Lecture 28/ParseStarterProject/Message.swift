//
//  Message.swift
//  Hello World
//
//  Created by Tingbo Chen on 4/9/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation
import CoreData


class Message: NSManagedObject {

    var isIncoming: Bool {
        return sender != nil
    }

}
