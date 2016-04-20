//
//  UIViewController+PhoneValidate.swift
//  Hello World
//
//  Created by Tingbo Chen on 4/20/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation
import UIKit

/*/====Extension====//
 Name: Phone Validation (000-000-0000)
 File: UIViewController+PhoneValidate.swift
 
 ===Description===
 View controller extension that allows you to 
 easily validate phone numbers using regular
 expressions. Example:
 phoneValidate("134-243-3432"); returns: true
 
 * Copyright 2016 d-cy.
 * Credit: Cy at http://www.d-cy.net
 * https://github.com/D-Cipher
 * License: GPL v3
 */

extension UIViewController {
    
    func phoneValidate(value: String) -> Bool {
        
        let regexPhoneNum = "^\\d{3}-\\d{3}-\\d{4}$"
        
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", regexPhoneNum)
        
        let result =  phoneTest.evaluateWithObject(value)
        
        return result
        
    }

}
