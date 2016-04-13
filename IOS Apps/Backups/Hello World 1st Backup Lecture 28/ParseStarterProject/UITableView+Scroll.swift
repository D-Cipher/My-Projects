//
//  UITableView+Scroll.swift
//  Hello World
//
//  Created by Tingbo Chen on 4/7/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation
import UIKit

/*/====Extension====//
 Name: TableView Scroll To Bottom
 File: UITableView+Scroll.swift
 Used in: MessageViewController
 
 ===Description===
 TableView controller extension that allows you to
 programmatically scroll to the bottom of the table.
 If the table has multiple sections, allows you it
 will scroll to the bottom of the last section.
 Great for chat views that require quickly scrolling to
 the last chat.
 
 * Copyright 2016 d-cy.
 * Credit: Cy at http://www.d-cy.net
 * https://github.com/D-Cipher
 * License: GPL v3
 */

extension UITableView {
    func scrollToBottom(animation: Bool) {
        
        if self.numberOfSections > 1 {
            
            let lastSection = self.numberOfSections - 1
            
            self.scrollToRowAtIndexPath(NSIndexPath(forRow: self.numberOfRowsInSection(lastSection)-1, inSection: lastSection), atScrollPosition: .Bottom, animated: animation)
            
        } else if numberOfRowsInSection(0) > 0 && self.numberOfSections == 1 {
            
            self.scrollToRowAtIndexPath(NSIndexPath(forRow: self.numberOfRowsInSection(0)-1, inSection: 0), atScrollPosition: .Bottom, animated: animation)
            
        }
    }
}

