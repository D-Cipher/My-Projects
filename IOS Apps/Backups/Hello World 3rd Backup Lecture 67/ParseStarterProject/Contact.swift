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
        
        let first_char = firstName?.characters.first
        var first_str = ""
        
        if first_char != nil {
            first_str = String(first_char!)
        } else {
            first_str = ""
        }
        
        let alphaNameTest = NSPredicate(format: "SELF MATCHES %@", "^([a-zA-Z])")
        
        let result = alphaNameTest.evaluateWithObject(first_str)
        
        guard result == true else {
            let symbol_str = "#"
            
            return symbol_str
        }
        
        return first_str
        
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
