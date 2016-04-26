//
//  UIViewController+OkAlert.swift
//  Hello World
//
//  Created by Tingbo Chen on 4/26/16.
//  Copyright © 2016 Parse. All rights reserved.
//

//
//  UIViewController+OkAlert.swift
//  Hello World
//
//  Created by Tingbo Chen on 4/20/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation
import UIKit

/*/====Extension====//
 Name: Simple Ok Alert
 File: UIViewController+OkAlert.swift
 
 ===Description===
 View controller extension that allows you to add a
 simple Ok alert that informs the user on app activity.
 
 * Copyright 2016 d-cy.
 * Credit: Cy at http://www.d-cy.net
 * https://github.com/D-Cipher
 * License: GPL v3
 */

extension UIViewController {
    
    func okAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

