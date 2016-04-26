//
//  ViewController+ActivityInd.swift
//  Hello World
//
//  Created by Tingbo Chen on 4/6/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation
import UIKit

/*/====Extension====//
 Name: Activity Indicator with Warning Message
 File: UIViewController+ActivityInd.swift
 
 ===Description===
 View controller extension that allows you to add a
 simple activity indicator with a warning message
 to your project, so that your users know what the heck
 is going on when you throw them an that activity indicator
 spinner.
 
 * Copyright 2016 d-cy.
 * Credit: Cy at http://www.d-cy.net
 * https://github.com/D-Cipher
 * License: GPL v3
 */

extension UIViewController {
    
    public struct WarningVar {
        public static var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        public static var msgFrame = UIView()
        public static var label = UILabel()
    }
    
    //Activity Indicator
    func activityIndFunc(status: Int, warningMsg: String = "Loading...") {
        
        if status == 1 {
            
            WarningVar.label = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
            WarningVar.label.text = warningMsg
            WarningVar.label.textColor = UIColor.whiteColor()
            WarningVar.msgFrame = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25 , width: 180, height: 50))
            WarningVar.msgFrame.layer.cornerRadius = 15
            WarningVar.msgFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)

            WarningVar.actInd = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            WarningVar.actInd.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            WarningVar.actInd.startAnimating()
            
            WarningVar.msgFrame.addSubview(WarningVar.actInd)
            WarningVar.msgFrame.addSubview(WarningVar.label)
            view.addSubview(WarningVar.msgFrame)
            
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
        } else if status == 0 {
            
            dispatch_async(dispatch_get_main_queue()) {
                WarningVar.msgFrame.removeFromSuperview()
                WarningVar.actInd.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
            }
        }

    }
    
}