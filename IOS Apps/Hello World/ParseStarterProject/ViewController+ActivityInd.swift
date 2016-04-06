//
//  ViewController+ActivityInd.swift
//  Hello World
//
//  Created by Tingbo Chen on 4/6/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    public struct WarningVar {
        public static var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        public static var messageFrame = UIView()
        public static var strLabel = UILabel()
    }
    
    //Activity Indicator
    func activityIndFunc(status: Int, warningMsg: String = "Loading...") {
        
        if status == 1 {
            
            WarningVar.strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
            WarningVar.strLabel.text = warningMsg
            WarningVar.strLabel.textColor = UIColor.whiteColor()
            WarningVar.messageFrame = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25 , width: 180, height: 50))
            WarningVar.messageFrame.layer.cornerRadius = 15
            WarningVar.messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)

            WarningVar.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            WarningVar.activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            WarningVar.activityIndicator.startAnimating()
            
            WarningVar.messageFrame.addSubview(WarningVar.activityIndicator)
            WarningVar.messageFrame.addSubview(WarningVar.strLabel)
            view.addSubview(WarningVar.messageFrame)
            
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
        } else if status == 0 {
            
            dispatch_async(dispatch_get_main_queue()) {
                WarningVar.messageFrame.removeFromSuperview()
                WarningVar.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
            }
        }

    }
    
}