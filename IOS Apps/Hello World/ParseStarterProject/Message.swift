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
        get {
            guard let incoming = incoming else {return false}
            return incoming.boolValue
        } set (incoming) {
            self.incoming = incoming
        }
    }

}
