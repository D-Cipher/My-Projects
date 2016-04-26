//
//  UIViewController+FillWithView.swift
//  Hello World
//
//  Created by Tingbo Chen on 4/11/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation
import UIKit

/*/====Extension====//
 Name: Fill With View
 File: UIViewController+FillWithView.swift
 
 ===Description===
 View Controller extension that configures a subview to 
 take up the entire screen (accounting for potential nav bar,
 or tab bar).
 
 * Copyright 2016 d-cy.
 * Credit: Cy at http://www.d-cy.net
 * https://github.com/D-Cipher
 * License: GPL v3
 */

extension UIViewController {
    func fillWithView(subview: UIView) {
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(subview)
        
        let subviewConstraints: [NSLayoutConstraint] = [
            subview.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor),
            subview.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
            subview.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
            subview.bottomAnchor.constraintEqualToAnchor(bottomLayoutGuide.topAnchor)
        ]
        
        NSLayoutConstraint.activateConstraints(subviewConstraints)
        
    }
    
}