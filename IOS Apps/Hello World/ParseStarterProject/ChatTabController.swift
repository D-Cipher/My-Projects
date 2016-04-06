//
//  ChatTabController.swift
//  ParseStarterProject
//
//  Created by Tingbo Chen on 2/23/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse
import Foundation

class ChatTabController: UIViewController {
    
    var userProfileData = Dictionary<String,AnyObject>()
    
    var userProfileImages = Dictionary<String,AnyObject>()
    
    @IBAction func printSavedData(sender: AnyObject) { // For Testing
        print(userProfileData)
        //print(userProfileImages)
    }

    @IBAction func printPermStorage(sender: AnyObject) { // For Testing
        
        if NSUserDefaults().objectForKey("userProfileData") != nil {
            self.userProfileData = NSUserDefaults().objectForKey("userProfileData")! as! NSDictionary as! Dictionary<String,AnyObject>
            print("data exits")
            
        }
        
        if NSUserDefaults().objectForKey("userProfileImages") != nil {
            self.userProfileImages = NSUserDefaults().objectForKey("userProfileImages")! as! NSDictionary as! Dictionary<String,AnyObject>
            print("pics exist")
            
        }
        
        
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get user Profile Preferences from Parse
        //if user exists in parse then save userprofiledata to perm data
        //if perm data is not empty then
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
