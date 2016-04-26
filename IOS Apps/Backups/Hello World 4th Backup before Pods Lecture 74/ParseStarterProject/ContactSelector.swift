//
//  ContactSelector.swift
//  Hello World
//
//  Created by Tingbo Chen on 4/15/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation

/*/====Extension====//
 File: ContactSelector.swift
 
 ===Description===
 Extension that tells us which contact is selected.
 
 * Copyright 2016 d-cy.
 * Credit: Cy at http://www.d-cy.net
 * https://github.com/D-Cipher
 * License: GPL v3
 */

protocol ContactSelector {
    func selectedContact(contact: Contact)
    
}