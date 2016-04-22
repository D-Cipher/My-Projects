//
//  Message+Firebase.swift
//  Hello World
//
//  Created by Tingbo Chen on 4/22/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation
import Firebase
import CoreData

extension Message: FirebaseModel {
    func upload(rootRef: Firebase, context: NSManagedObjectContext) {
        if chat?.storageID == nil {
            chat?.upload(rootRef, context: context)
        }
        let data = [
            "message" : text!,
            "sender" : FirebaseStore.currentPhoneNumber!
        ]
        guard let chat = chat, timestamp = timestamp, storageID = chat.storageID else {return}
        
        let timeInterval = String(Int(timestamp.timeIntervalSince1970 * 100000))
        
        rootRef.childByAppendingPath("chats/"+storageID+"/messages/"+timeInterval).setValue(data)
    }
}
