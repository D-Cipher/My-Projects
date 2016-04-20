//
//  Contact.swift
//  Hello World
//
//  Created by Tingbo Chen on 4/10/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation
import CoreData


class Contact: NSManagedObject {

    var sortLetter: String {
        let letter = lastName?.characters.first ?? firstName?.characters.first
        
        let letter_str = String(letter!)
        
        return letter_str
    }
    
    var fullName: String {
        
        var fullName = ""
        
        if let firstName = firstName {
            fullName += firstName
        }
        if let lastName = lastName {
            if fullName.characters.count > 0 {
                fullName += " "
            }
            fullName += lastName
        }
        return fullName
    }

}
